import { onRequest } from "firebase-functions/v2/https";
import { defineString } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import { FirebaseAnalyticsService } from "../services/firebaseAnalytics";
import { AppConfigService } from "../services/appConfig";
import { AdMobService } from "../services/admob";
import { AppStoreConnectService } from "../services/appStoreConnect";

// AdMob API用の環境変数（オプション）
const admobClientId = defineString("ADMOB_CLIENT_ID");
const admobClientSecret = defineString("ADMOB_CLIENT_SECRET");
const admobRefreshToken = defineString("ADMOB_REFRESH_TOKEN");
const admobPublisherId = defineString("ADMOB_PUBLISHER_ID");

// App Store Connect用の環境変数
const appStoreIssuerId = defineString("APP_STORE_ISSUER_ID");
const appStoreKeyId = defineString("APP_STORE_KEY_ID");
const appStorePrivateKey = defineString("APP_STORE_PRIVATE_KEY");
const appStoreVendorNumber = defineString("APP_STORE_VENDOR_NUMBER");

/**
 * KPIレスポンスの型定義
 */
interface KPIResponse {
  success: boolean;
  data?: {
    appName: string;
    appId: string;
    period: string;
    metrics: {
      // ユーザーメトリクス
      dau: number;
      mau?: number;
      wau?: number;
      newUsers: number;
      sessions: number;
      screenPageViews: number;
      // 比較データ
      dauChangePercent?: number;
      // トレンドデータ（オプション）
      trend?: Array<{
        date: string;
        activeUsers: number;
        newUsers: number;
        sessions: number;
      }>;
      // 収益データ（オプション）
      revenue?: {
        estimatedEarnings: number;
        impressions: number;
        clicks: number;
        ecpm: number;
      };
      // ダウンロードデータ（オプション）
      downloads?: {
        daily: number;
        redownloads: number;
        total: number;
      };
    };
    generatedAt: string;
  };
  error?: string;
}

/**
 * サマリーレスポンスの型定義
 */
interface SummaryResponse {
  success: boolean;
  data?: {
    period: string;
    appCount: number;
    totals: {
      dau: number;
      newUsers: number;
      sessions: number;
      revenue: number;
    };
    apps: Array<{
      appName: string;
      appId: string;
      dau: number;
      newUsers: number;
      sessions: number;
      revenue: number;
      rank: number;
    }>;
    generatedAt: string;
  };
  error?: string;
}

/**
 * 単一アプリのKPIを取得するHTTPS関数
 *
 * クエリパラメータ:
 * - appId: アプリID（metrics_appsのドキュメントID）
 * - period: "daily" | "weekly" | "monthly" (デフォルト: daily)
 * - includeTrend: "true" | "false" (デフォルト: false)
 * - includeRevenue: "true" | "false" (デフォルト: false)
 * - includeDownloads: "true" | "false" (デフォルト: false)
 *
 * 例: /getMetrics?appId=crelve-jh-english&period=daily&includeTrend=true
 */
export const getMetrics = onRequest(
  {
    memory: "256MiB",
    timeoutSeconds: 60,
    cors: true,
  },
  async (req, res) => {
    // GETメソッドのみ許可
    if (req.method !== "GET") {
      res.status(405).json({ success: false, error: "Method not allowed" });
      return;
    }

    const appId = req.query.appId as string;
    const period = (req.query.period as string) || "daily";
    const includeTrend = req.query.includeTrend === "true";
    const includeRevenue = req.query.includeRevenue === "true";
    const includeDownloads = req.query.includeDownloads === "true";

    if (!appId) {
      res.status(400).json({ success: false, error: "appId is required" });
      return;
    }

    try {
      const appConfigService = new AppConfigService();
      const app = await appConfigService.getAppConfig(appId);

      if (!app) {
        res.status(404).json({ success: false, error: `App not found: ${appId}` });
        return;
      }

      const analyticsService = new FirebaseAnalyticsService(app.analyticsPropertyId);

      let metrics: KPIResponse["data"];

      if (period === "weekly") {
        const weeklyData = await analyticsService.getWeeklySummary();
        metrics = {
          appName: app.appName,
          appId: appId,
          period: "weekly",
          metrics: {
            dau: weeklyData.avgDailyActiveUsers,
            wau: weeklyData.totalActiveUsers,
            newUsers: weeklyData.totalNewUsers,
            sessions: weeklyData.totalSessions,
            screenPageViews: 0,
            dauChangePercent: weeklyData.previousWeekComparison,
          },
          generatedAt: new Date().toISOString(),
        };
      } else if (period === "monthly") {
        const monthlyData = await analyticsService.getMonthlySummary();
        metrics = {
          appName: app.appName,
          appId: appId,
          period: "monthly",
          metrics: {
            dau: monthlyData.avgDailyActiveUsers,
            mau: monthlyData.totalActiveUsers,
            newUsers: monthlyData.totalNewUsers,
            sessions: monthlyData.totalSessions,
            screenPageViews: 0,
            dauChangePercent: monthlyData.previousMonthComparison,
          },
          generatedAt: new Date().toISOString(),
        };
      } else {
        // daily (デフォルト)
        const [dailyData, weeklyComparison] = await Promise.all([
          analyticsService.getYesterdayMetrics(),
          analyticsService.getWeeklyComparison(),
        ]);
        metrics = {
          appName: app.appName,
          appId: appId,
          period: "daily",
          metrics: {
            dau: dailyData.activeUsers,
            newUsers: dailyData.newUsers,
            sessions: dailyData.sessions,
            screenPageViews: dailyData.screenPageViews,
            dauChangePercent: weeklyComparison.changePercent,
          },
          generatedAt: new Date().toISOString(),
        };
      }

      // トレンドデータを追加
      if (includeTrend) {
        const days = period === "monthly" ? 30 : period === "weekly" ? 14 : 7;
        const trendData = await analyticsService.getDAUTrend(days);
        metrics.metrics.trend = trendData.map((d) => ({
          date: d.date,
          activeUsers: d.activeUsers,
          newUsers: d.newUsers,
          sessions: d.sessions,
        }));
      }

      // 収益データを追加
      if (includeRevenue && app.admobAppId) {
        const admobConfig = admobClientId.value() && admobRefreshToken.value() ? {
          clientId: admobClientId.value(),
          clientSecret: admobClientSecret.value(),
          refreshToken: admobRefreshToken.value(),
          publisherId: admobPublisherId.value(),
        } : null;

        if (admobConfig) {
          try {
            const admobService = new AdMobService(admobConfig);
            const admobMetrics = await admobService.getYesterdayMetrics(app.admobAppId);
            metrics.metrics.revenue = {
              estimatedEarnings: admobMetrics.estimatedEarnings,
              impressions: admobMetrics.impressions,
              clicks: admobMetrics.clicks,
              ecpm: admobMetrics.ecpm,
            };
          } catch (admobError) {
            logger.warn(`AdMob metrics failed for ${appId}:`, admobError);
          }
        }
      }

      // ダウンロードデータを追加
      if (includeDownloads && app.appStoreAppId) {
        try {
          const appStoreService = new AppStoreConnectService({
            issuerId: appStoreIssuerId.value(),
            keyId: appStoreKeyId.value(),
            privateKey: appStorePrivateKey.value(),
            vendorNumber: appStoreVendorNumber.value(),
            appId: app.appStoreAppId,
          });
          const downloadMetrics = await appStoreService.getYesterdayDownloads();
          metrics.metrics.downloads = {
            daily: downloadMetrics.downloads,
            redownloads: downloadMetrics.redownloads,
            total: downloadMetrics.totalDownloads,
          };
        } catch (downloadError) {
          logger.warn(`Download metrics failed for ${appId}:`, downloadError);
        }
      }

      const response: KPIResponse = {
        success: true,
        data: metrics,
      };

      res.status(200).json(response);
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : "Unknown error";
      logger.error(`Failed to get metrics for ${appId}:`, error);
      res.status(500).json({ success: false, error: errorMessage });
    }
  }
);

/**
 * 全アプリのKPIサマリーを取得するHTTPS関数
 *
 * クエリパラメータ:
 * - period: "daily" | "weekly" | "monthly" (デフォルト: daily)
 *
 * 例: /getMetricsSummary?period=daily
 */
export const getMetricsSummary = onRequest(
  {
    memory: "512MiB",
    timeoutSeconds: 120,
    cors: true,
  },
  async (req, res) => {
    if (req.method !== "GET") {
      res.status(405).json({ success: false, error: "Method not allowed" });
      return;
    }

    const period = (req.query.period as string) || "daily";

    try {
      const appConfigService = new AppConfigService();
      const apps = await appConfigService.getEnabledApps();

      if (apps.length === 0) {
        res.status(404).json({ success: false, error: "No enabled apps found" });
        return;
      }

      // AdMob設定
      const admobConfig = admobClientId.value() && admobRefreshToken.value() ? {
        clientId: admobClientId.value(),
        clientSecret: admobClientSecret.value(),
        refreshToken: admobRefreshToken.value(),
        publisherId: admobPublisherId.value(),
      } : null;

      // 全アプリのメトリクスを並列取得
      const appMetrics = await Promise.all(
        apps.map(async (app) => {
          try {
            const analyticsService = new FirebaseAnalyticsService(app.analyticsPropertyId);

            let dau = 0;
            let newUsers = 0;
            let sessions = 0;

            if (period === "weekly") {
              const data = await analyticsService.getWeeklySummary();
              dau = data.avgDailyActiveUsers;
              newUsers = data.totalNewUsers;
              sessions = data.totalSessions;
            } else if (period === "monthly") {
              const data = await analyticsService.getMonthlySummary();
              dau = data.avgDailyActiveUsers;
              newUsers = data.totalNewUsers;
              sessions = data.totalSessions;
            } else {
              const data = await analyticsService.getYesterdayMetrics();
              dau = data.activeUsers;
              newUsers = data.newUsers;
              sessions = data.sessions;
            }

            // 収益取得
            let revenue = 0;
            if (admobConfig && app.admobAppId) {
              try {
                const admobService = new AdMobService(admobConfig);
                const admobMetrics = await admobService.getYesterdayMetrics(app.admobAppId);
                revenue = admobMetrics.estimatedEarnings;
              } catch {
                // 収益取得失敗は無視
              }
            }

            return {
              appName: app.appName,
              appId: app.id || "",
              dau,
              newUsers,
              sessions,
              revenue,
              priority: app.priority,
            };
          } catch (error) {
            logger.warn(`Failed to get metrics for ${app.appName}:`, error);
            return {
              appName: app.appName,
              appId: app.id || "",
              dau: 0,
              newUsers: 0,
              sessions: 0,
              revenue: 0,
              priority: app.priority,
            };
          }
        })
      );

      // 動的順位でソート: 収益(降順) → DAU(降順) → priority(昇順)
      const sortedApps = [...appMetrics].sort((a, b) => {
        if (a.revenue !== b.revenue) return b.revenue - a.revenue;
        if (a.dau !== b.dau) return b.dau - a.dau;
        return a.priority - b.priority;
      });

      // ランク付け
      const rankedApps = sortedApps.map((app, index) => ({
        ...app,
        rank: index + 1,
      }));

      // 合計計算
      const totals = {
        dau: appMetrics.reduce((sum, a) => sum + a.dau, 0),
        newUsers: appMetrics.reduce((sum, a) => sum + a.newUsers, 0),
        sessions: appMetrics.reduce((sum, a) => sum + a.sessions, 0),
        revenue: appMetrics.reduce((sum, a) => sum + a.revenue, 0),
      };

      const response: SummaryResponse = {
        success: true,
        data: {
          period,
          appCount: apps.length,
          totals,
          apps: rankedApps.map(({ priority, ...rest }) => rest),
          generatedAt: new Date().toISOString(),
        },
      };

      res.status(200).json(response);
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : "Unknown error";
      logger.error("Failed to get metrics summary:", error);
      res.status(500).json({ success: false, error: errorMessage });
    }
  }
);

/**
 * DAUトレンドを取得するHTTPS関数
 *
 * クエリパラメータ:
 * - appId: アプリID（metrics_appsのドキュメントID）
 * - days: 取得日数 (デフォルト: 7, 最大: 90)
 *
 * 例: /getDAUTrend?appId=crelve-jh-english&days=30
 */
export const getDAUTrend = onRequest(
  {
    memory: "256MiB",
    timeoutSeconds: 60,
    cors: true,
  },
  async (req, res) => {
    if (req.method !== "GET") {
      res.status(405).json({ success: false, error: "Method not allowed" });
      return;
    }

    const appId = req.query.appId as string;
    const days = Math.min(parseInt(req.query.days as string) || 7, 90);

    if (!appId) {
      res.status(400).json({ success: false, error: "appId is required" });
      return;
    }

    try {
      const appConfigService = new AppConfigService();
      const app = await appConfigService.getAppConfig(appId);

      if (!app) {
        res.status(404).json({ success: false, error: `App not found: ${appId}` });
        return;
      }

      const analyticsService = new FirebaseAnalyticsService(app.analyticsPropertyId);
      const trend = await analyticsService.getDAUTrend(days);

      res.status(200).json({
        success: true,
        data: {
          appName: app.appName,
          appId,
          days,
          trend,
          generatedAt: new Date().toISOString(),
        },
      });
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : "Unknown error";
      logger.error(`Failed to get DAU trend for ${appId}:`, error);
      res.status(500).json({ success: false, error: errorMessage });
    }
  }
);
