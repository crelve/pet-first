import { onSchedule } from "firebase-functions/v2/scheduler";
import { defineString } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import { AppStoreConnectService } from "../services/appStoreConnect";
import { FirebaseAnalyticsService } from "../services/firebaseAnalytics";
import { SlackNotificationService } from "../services/slack";
import { AppConfigService, AppConfig } from "../services/appConfig";
import { AdMobService } from "../services/admob";

// 環境変数で機密情報を管理（Secret Managerから移行してコスト削減）
const slackWebhookUrl = defineString("SLACK_WEBHOOK_URL");
const appStoreIssuerId = defineString("APP_STORE_ISSUER_ID");
const appStoreKeyId = defineString("APP_STORE_KEY_ID");
const appStorePrivateKey = defineString("APP_STORE_PRIVATE_KEY");
const appStoreVendorNumber = defineString("APP_STORE_VENDOR_NUMBER");

// AdMob API用の環境変数（オプション）
const admobClientId = defineString("ADMOB_CLIENT_ID");
const admobClientSecret = defineString("ADMOB_CLIENT_SECRET");
const admobRefreshToken = defineString("ADMOB_REFRESH_TOKEN");
const admobPublisherId = defineString("ADMOB_PUBLISHER_ID");

/**
 * 収集したメトリクスデータの型
 */
interface CollectedMetrics {
  app: AppConfig;
  date: string;
  downloads: number;
  redownloads: number;
  totalDownloads: number;
  activeUsers: number;
  newUsers: number;
  sessions: number;
  weeklyChangePercent: number;
  revenue?: {
    estimatedEarnings: number;
    impressions: number;
    clicks: number;
    ecpm: number;
  };
  error?: string; // エラーが発生した場合
}

/**
 * 毎日AM 9:00 (JST) に実行される日次メトリクスレポート
 * Firestoreに登録された全アプリのメトリクスを取得してSlackに通知
 *
 * 順位付けロジック:
 * 1. 推定収益（高い順）
 * 2. DAU（高い順）
 * 3. priority（小さい順）
 */
export const dailyMetricsReport = onSchedule(
  {
    schedule: "0 7 * * *", // 毎日 AM 7:00
    timeZone: "Asia/Tokyo",
    memory: "512MiB",
    timeoutSeconds: 300, // 複数アプリ対応のため延長
  },
  async () => {
    logger.info("Starting daily metrics report for all apps...");

    const errorSlackService = new SlackNotificationService(
      slackWebhookUrl.value(),
      "System"
    );

    const appConfigService = new AppConfigService();

    try {
      // Firestoreから有効なアプリ一覧を取得
      const apps = await appConfigService.getEnabledApps();

      if (apps.length === 0) {
        logger.warn("No enabled apps found. Skipping report.");
        return;
      }

      logger.info(`Processing ${apps.length} app(s)...`);

      // AdMob設定（シークレットが設定されている場合のみ有効）
      const admobConfig = admobClientId.value() && admobRefreshToken.value() ? {
        clientId: admobClientId.value(),
        clientSecret: admobClientSecret.value(),
        refreshToken: admobRefreshToken.value(),
        publisherId: admobPublisherId.value(),
      } : null;

      const appStoreConfig = {
        issuerId: appStoreIssuerId.value(),
        keyId: appStoreKeyId.value(),
        privateKey: appStorePrivateKey.value(),
        vendorNumber: appStoreVendorNumber.value(),
      };

      // 全アプリのメトリクスを並列で取得
      const metricsResults = await Promise.all(
        apps.map((app) => collectAppMetrics(app, appStoreConfig, admobConfig))
      );

      // 成功したメトリクスとエラーを分離
      const successMetrics = metricsResults.filter((m) => !m.error);
      const errorMetrics = metricsResults.filter((m) => m.error);

      // 動的順位でソート: 収益(降順) → DAU(降順) → priority(昇順)
      const sortedMetrics = sortByDynamicRank(successMetrics);

      logger.info(`Sorted ${sortedMetrics.length} apps by dynamic rank`);

      // ソート順にSlack通知を送信
      for (let i = 0; i < sortedMetrics.length; i++) {
        const metrics = sortedMetrics[i];
        const rank = i + 1; // 1-indexed rank

        const slackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          metrics.app.appName
        );

        await slackService.sendDailyReport({
          date: metrics.date,
          downloads: metrics.downloads,
          redownloads: metrics.redownloads,
          totalDownloads: metrics.totalDownloads,
          activeUsers: metrics.activeUsers,
          newUsers: metrics.newUsers,
          sessions: metrics.sessions,
          weeklyChangePercent: metrics.weeklyChangePercent,
          rank, // 動的順位
          revenue: metrics.revenue,
        });

        logger.info(`[${metrics.app.appName}] Report sent (rank: ${rank})`);
      }

      // 全体サマリーを計算して送信
      if (sortedMetrics.length > 0) {
        const summarySlackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          "Summary"
        );

        const totalRevenue = sortedMetrics.reduce(
          (sum, m) => sum + (m.revenue?.estimatedEarnings ?? 0),
          0
        );
        const totalActiveUsers = sortedMetrics.reduce(
          (sum, m) => sum + m.activeUsers,
          0
        );
        const totalNewUsers = sortedMetrics.reduce(
          (sum, m) => sum + m.newUsers,
          0
        );
        const totalSessions = sortedMetrics.reduce(
          (sum, m) => sum + m.sessions,
          0
        );

        await summarySlackService.sendDailySummary({
          date: sortedMetrics[0].date,
          appCount: sortedMetrics.length,
          totalRevenue,
          totalActiveUsers,
          totalNewUsers,
          totalSessions,
        });

        logger.info("Daily summary sent");
      }

      // エラーがあったアプリの通知
      for (const errorApp of errorMetrics) {
        const slackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          errorApp.app.appName
        );
        await slackService.sendErrorNotification(errorApp.error!);
      }

      logger.info("Daily metrics report completed for all apps");
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : "Unknown error";
      logger.error("Daily metrics report failed:", error);

      await errorSlackService.sendErrorNotification(
        `全体エラー: ${errorMessage}`
      );
    }
  }
);

/**
 * 単一アプリのメトリクスを収集（Slack通知はしない）
 */
async function collectAppMetrics(
  app: AppConfig,
  appStoreConfig: {
    issuerId: string;
    keyId: string;
    privateKey: string;
    vendorNumber: string;
  },
  admobConfig: {
    clientId: string;
    clientSecret: string;
    refreshToken: string;
    publisherId: string;
  } | null
): Promise<CollectedMetrics> {
  try {
    logger.info(`Collecting metrics for: ${app.appName}`);

    const appStoreService = new AppStoreConnectService({
      ...appStoreConfig,
      appId: app.appStoreAppId,
    });

    const analyticsService = new FirebaseAnalyticsService(
      app.analyticsPropertyId
    );

    // 並行してデータ取得
    const [downloadMetrics, analyticsMetrics, weeklyComparison] =
      await Promise.all([
        appStoreService.getYesterdayDownloads(),
        analyticsService.getYesterdayMetrics(),
        analyticsService.getWeeklyComparison(),
      ]);

    logger.info(`[${app.appName}] Download metrics:`, downloadMetrics);
    logger.info(`[${app.appName}] Analytics metrics:`, analyticsMetrics);

    // AdMob収益を取得（設定がある場合のみ）
    let revenueMetrics = undefined;
    if (admobConfig && app.admobAppId) {
      try {
        const admobService = new AdMobService(admobConfig);
        const admobMetrics = await admobService.getYesterdayMetrics(app.admobAppId);
        revenueMetrics = {
          estimatedEarnings: admobMetrics.estimatedEarnings,
          impressions: admobMetrics.impressions,
          clicks: admobMetrics.clicks,
          ecpm: admobMetrics.ecpm,
        };
        logger.info(`[${app.appName}] AdMob metrics:`, revenueMetrics);
      } catch (admobError) {
        logger.warn(`[${app.appName}] AdMob metrics failed (continuing without):`, admobError);
      }
    }

    return {
      app,
      date: downloadMetrics.date,
      downloads: downloadMetrics.downloads,
      redownloads: downloadMetrics.redownloads,
      totalDownloads: downloadMetrics.totalDownloads,
      activeUsers: analyticsMetrics.activeUsers,
      newUsers: analyticsMetrics.newUsers,
      sessions: analyticsMetrics.sessions,
      weeklyChangePercent: weeklyComparison.changePercent,
      revenue: revenueMetrics,
    };
  } catch (error) {
    const errorMessage =
      error instanceof Error ? error.message : "Unknown error";
    logger.error(`[${app.appName}] Failed to collect metrics:`, error);

    return {
      app,
      date: new Date().toISOString().split("T")[0],
      downloads: 0,
      redownloads: 0,
      totalDownloads: 0,
      activeUsers: 0,
      newUsers: 0,
      sessions: 0,
      weeklyChangePercent: 0,
      error: errorMessage,
    };
  }
}

/**
 * 動的順位でソート
 * 1. 推定収益（高い順）
 * 2. DAU（高い順）
 * 3. priority（小さい順）
 */
function sortByDynamicRank(metrics: CollectedMetrics[]): CollectedMetrics[] {
  return [...metrics].sort((a, b) => {
    // 1. 推定収益（高い順）
    const revenueA = a.revenue?.estimatedEarnings ?? 0;
    const revenueB = b.revenue?.estimatedEarnings ?? 0;
    if (revenueA !== revenueB) {
      return revenueB - revenueA; // 降順
    }

    // 2. DAU（高い順）
    if (a.activeUsers !== b.activeUsers) {
      return b.activeUsers - a.activeUsers; // 降順
    }

    // 3. priority（小さい順）
    return a.app.priority - b.app.priority; // 昇順
  });
}
