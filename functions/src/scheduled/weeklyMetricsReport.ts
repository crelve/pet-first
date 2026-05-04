import { onSchedule } from "firebase-functions/v2/scheduler";
import { defineString } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import { FirebaseAnalyticsService } from "../services/firebaseAnalytics";
import { SlackNotificationService } from "../services/slack";
import { AppConfigService, AppConfig } from "../services/appConfig";

// 環境変数で機密情報を管理（Secret Managerから移行してコスト削減）
const slackWebhookUrl = defineString("SLACK_WEBHOOK_URL");

/**
 * 収集した週次メトリクスデータの型
 */
interface CollectedWeeklyMetrics {
  app: AppConfig;
  startDate: string;
  endDate: string;
  totalActiveUsers: number;
  totalNewUsers: number;
  totalSessions: number;
  avgDailyActiveUsers: number;
  previousWeekComparison: number;
  error?: string;
}

/**
 * 毎週月曜日 AM 9:00 (JST) に実行される週次メトリクスレポート
 * Firestoreに登録された全アプリの週次サマリーをSlackに通知
 *
 * 順位付けロジック:
 * 1. WAU（高い順）
 * 2. priority（小さい順）
 */
export const weeklyMetricsReport = onSchedule(
  {
    schedule: "0 7 * * 1", // 毎週月曜日 AM 7:00
    timeZone: "Asia/Tokyo",
    memory: "512MiB",
    timeoutSeconds: 300,
  },
  async () => {
    logger.info("Starting weekly metrics report for all apps...");

    const errorSlackService = new SlackNotificationService(
      slackWebhookUrl.value(),
      "System"
    );

    const appConfigService = new AppConfigService();

    try {
      const apps = await appConfigService.getEnabledApps();

      if (apps.length === 0) {
        logger.warn("No enabled apps found. Skipping weekly report.");
        return;
      }

      logger.info(`Processing weekly report for ${apps.length} app(s)...`);

      // 全アプリのメトリクスを並列で取得
      const metricsResults = await Promise.all(
        apps.map((app) => collectWeeklyMetrics(app))
      );

      // 成功したメトリクスとエラーを分離
      const successMetrics = metricsResults.filter((m) => !m.error);
      const errorMetrics = metricsResults.filter((m) => m.error);

      // 動的順位でソート: WAU(降順) → priority(昇順)
      const sortedMetrics = sortByDynamicRank(successMetrics);

      logger.info(`Sorted ${sortedMetrics.length} apps by dynamic rank (WAU)`);

      // ソート順にSlack通知を送信
      for (let i = 0; i < sortedMetrics.length; i++) {
        const metrics = sortedMetrics[i];
        const rank = i + 1;

        const slackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          metrics.app.appName
        );

        await slackService.sendWeeklyReport({
          startDate: metrics.startDate,
          endDate: metrics.endDate,
          totalActiveUsers: metrics.totalActiveUsers,
          totalNewUsers: metrics.totalNewUsers,
          totalSessions: metrics.totalSessions,
          avgDailyActiveUsers: metrics.avgDailyActiveUsers,
          previousWeekComparison: metrics.previousWeekComparison,
          rank,
        });

        logger.info(`[${metrics.app.appName}] Weekly report sent (rank: ${rank})`);
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

        await summarySlackService.sendWeeklySummary({
          startDate: sortedMetrics[0].startDate,
          endDate: sortedMetrics[0].endDate,
          appCount: sortedMetrics.length,
          totalActiveUsers,
          totalNewUsers,
          totalSessions,
        });

        logger.info("Weekly summary sent");
      }

      // エラーがあったアプリの通知
      for (const errorApp of errorMetrics) {
        const slackService = new SlackNotificationService(
          slackWebhookUrl.value(),
          errorApp.app.appName
        );
        await slackService.sendErrorNotification(
          `週次レポートエラー: ${errorApp.error}`
        );
      }

      logger.info("Weekly metrics report completed for all apps");
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : "Unknown error";
      logger.error("Weekly metrics report failed:", error);

      await errorSlackService.sendErrorNotification(
        `週次レポート全体エラー: ${errorMessage}`
      );
    }
  }
);

/**
 * 単一アプリの週次メトリクスを収集
 */
async function collectWeeklyMetrics(
  app: AppConfig
): Promise<CollectedWeeklyMetrics> {
  try {
    logger.info(`Collecting weekly metrics for: ${app.appName}`);

    const analyticsService = new FirebaseAnalyticsService(
      app.analyticsPropertyId
    );

    const weeklySummary = await analyticsService.getWeeklySummary();

    return {
      app,
      startDate: weeklySummary.startDate,
      endDate: weeklySummary.endDate,
      totalActiveUsers: weeklySummary.totalActiveUsers,
      totalNewUsers: weeklySummary.totalNewUsers,
      totalSessions: weeklySummary.totalSessions,
      avgDailyActiveUsers: weeklySummary.avgDailyActiveUsers,
      previousWeekComparison: weeklySummary.previousWeekComparison,
    };
  } catch (error) {
    const errorMessage =
      error instanceof Error ? error.message : "Unknown error";
    logger.error(`[${app.appName}] Failed to collect weekly metrics:`, error);

    return {
      app,
      startDate: "",
      endDate: "",
      totalActiveUsers: 0,
      totalNewUsers: 0,
      totalSessions: 0,
      avgDailyActiveUsers: 0,
      previousWeekComparison: 0,
      error: errorMessage,
    };
  }
}

/**
 * 動的順位でソート
 * 1. WAU（高い順）
 * 2. priority（小さい順）
 */
function sortByDynamicRank(
  metrics: CollectedWeeklyMetrics[]
): CollectedWeeklyMetrics[] {
  return [...metrics].sort((a, b) => {
    // 1. WAU（高い順）
    if (a.totalActiveUsers !== b.totalActiveUsers) {
      return b.totalActiveUsers - a.totalActiveUsers;
    }

    // 2. priority（小さい順）
    return a.app.priority - b.app.priority;
  });
}
