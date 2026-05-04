import { onSchedule } from "firebase-functions/v2/scheduler";
import { defineString } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import { FirebaseAnalyticsService } from "../services/firebaseAnalytics";
import { SlackNotificationService } from "../services/slack";
import { AppConfigService, AppConfig } from "../services/appConfig";

// 環境変数で機密情報を管理（Secret Managerから移行してコスト削減）
const slackWebhookUrl = defineString("SLACK_WEBHOOK_URL");

/**
 * 収集した月次メトリクスデータの型
 */
interface CollectedMonthlyMetrics {
  app: AppConfig;
  month: string;
  startDate: string;
  endDate: string;
  totalActiveUsers: number;
  totalNewUsers: number;
  totalSessions: number;
  avgDailyActiveUsers: number;
  previousMonthComparison: number;
  error?: string;
}

/**
 * 毎月1日 AM 9:00 (JST) に実行される月次メトリクスレポート
 * Firestoreに登録された全アプリの前月サマリーをSlackに通知
 *
 * 順位付けロジック:
 * 1. MAU（高い順）
 * 2. priority（小さい順）
 */
export const monthlyMetricsReport = onSchedule(
  {
    schedule: "0 7 1 * *", // 毎月1日 AM 7:00
    timeZone: "Asia/Tokyo",
    memory: "512MiB",
    timeoutSeconds: 300,
  },
  async () => {
    logger.info("Starting monthly metrics report for all apps...");

    const errorSlackService = new SlackNotificationService(
      slackWebhookUrl.value(),
      "System"
    );

    const appConfigService = new AppConfigService();

    try {
      const apps = await appConfigService.getEnabledApps();

      if (apps.length === 0) {
        logger.warn("No enabled apps found. Skipping monthly report.");
        return;
      }

      logger.info(`Processing monthly report for ${apps.length} app(s)...`);

      // 全アプリのメトリクスを並列で取得
      const metricsResults = await Promise.all(
        apps.map((app) => collectMonthlyMetrics(app))
      );

      // 成功したメトリクスとエラーを分離
      const successMetrics = metricsResults.filter((m) => !m.error);
      const errorMetrics = metricsResults.filter((m) => m.error);

      // 動的順位でソート: MAU(降順) → priority(昇順)
      const sortedMetrics = sortByDynamicRank(successMetrics);

      logger.info(`Sorted ${sortedMetrics.length} apps by dynamic rank (MAU)`);

      // ソート順にSlack通知を送信
      for (let i = 0; i < sortedMetrics.length; i++) {
        const metrics = sortedMetrics[i];
        const rank = i + 1;

        const slackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          metrics.app.appName
        );

        await slackService.sendMonthlyReport({
          month: metrics.month,
          startDate: metrics.startDate,
          endDate: metrics.endDate,
          totalActiveUsers: metrics.totalActiveUsers,
          totalNewUsers: metrics.totalNewUsers,
          totalSessions: metrics.totalSessions,
          avgDailyActiveUsers: metrics.avgDailyActiveUsers,
          previousMonthComparison: metrics.previousMonthComparison,
          rank,
        });

        logger.info(`[${metrics.app.appName}] Monthly report sent (rank: ${rank})`);
      }

      // 全体サマリーを計算して送信
      if (sortedMetrics.length > 0) {
        const summarySlackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          "Summary"
        );

        const totalActiveUsers = sortedMetrics.reduce(
          (sum, m) => sum + m.totalActiveUsers,
          0
        );
        const totalNewUsers = sortedMetrics.reduce(
          (sum, m) => sum + m.totalNewUsers,
          0
        );
        const totalSessions = sortedMetrics.reduce(
          (sum, m) => sum + m.totalSessions,
          0
        );

        await summarySlackService.sendMonthlySummary({
          month: sortedMetrics[0].month,
          appCount: sortedMetrics.length,
          totalActiveUsers,
          totalNewUsers,
          totalSessions,
        });

        logger.info("Monthly summary sent");
      }

      // エラーがあったアプリの通知
      for (const errorApp of errorMetrics) {
        const slackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          errorApp.app.appName
        );
        await slackService.sendErrorNotification(
          `月次レポートエラー: ${errorApp.error}`
        );
      }

      logger.info("Monthly metrics report completed for all apps");
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : "Unknown error";
      logger.error("Monthly metrics report failed:", error);

      await errorSlackService.sendErrorNotification(
        `月次レポート全体エラー: ${errorMessage}`
      );
    }
  }
);

/**
 * 単一アプリの月次メトリクスを収集
 */
async function collectMonthlyMetrics(
  app: AppConfig
): Promise<CollectedMonthlyMetrics> {
  try {
    logger.info(`Collecting monthly metrics for: ${app.appName}`);

    const analyticsService = new FirebaseAnalyticsService(
      app.analyticsPropertyId
    );

    const monthlySummary = await analyticsService.getMonthlySummary();

    return {
      app,
      month: monthlySummary.month,
      startDate: monthlySummary.startDate,
      endDate: monthlySummary.endDate,
      totalActiveUsers: monthlySummary.totalActiveUsers,
      totalNewUsers: monthlySummary.totalNewUsers,
      totalSessions: monthlySummary.totalSessions,
      avgDailyActiveUsers: monthlySummary.avgDailyActiveUsers,
      previousMonthComparison: monthlySummary.previousMonthComparison,
    };
  } catch (error) {
    const errorMessage =
      error instanceof Error ? error.message : "Unknown error";
    logger.error(`[${app.appName}] Failed to collect monthly metrics:`, error);

    return {
      app,
      month: "",
      startDate: "",
      endDate: "",
      totalActiveUsers: 0,
      totalNewUsers: 0,
      totalSessions: 0,
      avgDailyActiveUsers: 0,
      previousMonthComparison: 0,
      error: errorMessage,
    };
  }
}

/**
 * 動的順位でソート
 * 1. MAU（高い順）
 * 2. priority（小さい順）
 */
function sortByDynamicRank(
  metrics: CollectedMonthlyMetrics[]
): CollectedMonthlyMetrics[] {
  return [...metrics].sort((a, b) => {
    // 1. MAU（高い順）
    if (a.totalActiveUsers !== b.totalActiveUsers) {
      return b.totalActiveUsers - a.totalActiveUsers;
    }

    // 2. priority（小さい順）
    return a.app.priority - b.app.priority;
  });
}
