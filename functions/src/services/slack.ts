import { IncomingWebhook, IncomingWebhookSendArguments } from "@slack/webhook";
import * as logger from "firebase-functions/logger";

interface DailyMetrics {
  date: string;
  downloads: number;
  redownloads: number;
  totalDownloads: number;
  activeUsers: number;
  newUsers: number;
  sessions: number;
  weeklyChangePercent?: number;
  rank: number; // 動的順位（収益→DAU→priority順）
  // AdMob収益（オプション）
  revenue?: {
    estimatedEarnings: number; // USD
    impressions: number;
    clicks: number;
    ecpm: number;
  };
}

interface WeeklyMetrics {
  startDate: string;
  endDate: string;
  totalActiveUsers: number;
  totalNewUsers: number;
  totalSessions: number;
  avgDailyActiveUsers: number;
  previousWeekComparison: number;
  rank: number; // 動的順位（WAU→priority順）
}

interface MonthlyMetrics {
  month: string;
  startDate: string;
  endDate: string;
  totalActiveUsers: number;
  totalNewUsers: number;
  totalSessions: number;
  avgDailyActiveUsers: number;
  previousMonthComparison: number;
  rank: number; // 動的順位（MAU→priority順）
}

/**
 * Slack通知サービス
 */
export class SlackNotificationService {
  private webhook: IncomingWebhook;
  private appName: string;

  constructor(webhookUrl: string, appName: string) {
    this.webhook = new IncomingWebhook(webhookUrl);
    this.appName = appName;
  }

  /**
   * 日次メトリクスレポートを送信
   */
  async sendDailyReport(metrics: DailyMetrics): Promise<void> {
    const changeEmoji = this.getChangeEmoji(metrics.weeklyChangePercent);
    const changeText = metrics.weeklyChangePercent !== undefined
      ? `${changeEmoji} ${metrics.weeklyChangePercent > 0 ? "+" : ""}${metrics.weeklyChangePercent}%`
      : "";

    // 収益行（収益がある場合のみ）
    const revenueLine = metrics.revenue
      ? `💰 *¥${Math.round(metrics.revenue.estimatedEarnings).toLocaleString()}*　｜　👁️ ${metrics.revenue.impressions.toLocaleString()}imp　｜　📊 eCPM ¥${Math.round(metrics.revenue.ecpm).toLocaleString()}`
      : "";

    // 週次比較行
    const weeklyLine = changeText ? `${changeText} vs 先週` : "";

    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "divider",
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `${this.getRankBadge(metrics.rank)}　*${this.appName}*　_${metrics.date}_`,
          },
        },
      ],
    };

    // 収益情報がある場合は先に追加
    if (revenueLine) {
      message.blocks?.push({
        type: "context",
        elements: [
          {
            type: "mrkdwn",
            text: revenueLine,
          },
        ],
      });
    }

    // DAU/新規/セッション行
    message.blocks?.push({
      type: "context",
      elements: [
        {
          type: "mrkdwn",
          text: `👥 *DAU* ${metrics.activeUsers.toLocaleString()}　｜　🆕 *新規* ${metrics.newUsers.toLocaleString()}　｜　📱 *セッション* ${metrics.sessions.toLocaleString()}`,
        },
      ],
    });

    // 週次比較がある場合は追加
    if (weeklyLine) {
      message.blocks?.push({
        type: "context",
        elements: [
          {
            type: "mrkdwn",
            text: weeklyLine,
          },
        ],
      });
    }

    try {
      await this.webhook.send(message);
      logger.info("Daily report sent to Slack successfully");
    } catch (error) {
      logger.error("Failed to send Slack notification:", error);
      throw error;
    }
  }

  /**
   * 週次サマリーレポートを送信
   */
  async sendWeeklyReport(metrics: WeeklyMetrics): Promise<void> {
    const changeEmoji = this.getChangeEmoji(metrics.previousWeekComparison);
    const changeText = `${changeEmoji} ${metrics.previousWeekComparison > 0 ? "+" : ""}${metrics.previousWeekComparison}% vs 前週`;

    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "divider",
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `${this.getRankBadge(metrics.rank)}　*${this.appName}*　_${metrics.startDate} 〜 ${metrics.endDate}_`,
          },
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: `👥 *WAU* ${metrics.totalActiveUsers.toLocaleString()}　｜　📊 *日平均* ${metrics.avgDailyActiveUsers.toLocaleString()}　｜　🆕 *新規* ${metrics.totalNewUsers.toLocaleString()}`,
            },
          ],
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: changeText,
            },
          ],
        },
      ],
    };

    try {
      await this.webhook.send(message);
      logger.info("Weekly report sent to Slack successfully");
    } catch (error) {
      logger.error("Failed to send weekly Slack notification:", error);
      throw error;
    }
  }

  /**
   * 月次サマリーレポートを送信
   */
  async sendMonthlyReport(metrics: MonthlyMetrics): Promise<void> {
    const changeEmoji = this.getChangeEmoji(metrics.previousMonthComparison);
    const changeText = `${changeEmoji} ${metrics.previousMonthComparison > 0 ? "+" : ""}${metrics.previousMonthComparison}% vs 前月`;

    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "divider",
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `${this.getRankBadge(metrics.rank)}　*${this.appName}*　_${metrics.month}_`,
          },
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: `👥 *MAU* ${metrics.totalActiveUsers.toLocaleString()}　｜　📊 *日平均* ${metrics.avgDailyActiveUsers.toLocaleString()}　｜　🆕 *新規* ${metrics.totalNewUsers.toLocaleString()}`,
            },
          ],
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: changeText,
            },
          ],
        },
      ],
    };

    try {
      await this.webhook.send(message);
      logger.info("Monthly report sent to Slack successfully");
    } catch (error) {
      logger.error("Failed to send monthly Slack notification:", error);
      throw error;
    }
  }

  /**
   * 日次サマリー（全アプリ合計）を送信
   */
  async sendDailySummary(summary: {
    date: string;
    appCount: number;
    totalRevenue: number;
    totalActiveUsers: number;
    totalNewUsers: number;
    totalSessions: number;
  }): Promise<void> {
    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "divider",
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `📊　*Daily Summary*　_${summary.date}_　（${summary.appCount}アプリ）`,
          },
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: `💰 *合計収益* ¥${Math.round(summary.totalRevenue).toLocaleString()}`,
            },
          ],
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: `👥 *合計DAU* ${summary.totalActiveUsers.toLocaleString()}　｜　🆕 *合計新規* ${summary.totalNewUsers.toLocaleString()}　｜　📱 *合計セッション* ${summary.totalSessions.toLocaleString()}`,
            },
          ],
        },
      ],
    };

    try {
      await this.webhook.send(message);
      logger.info("Daily summary sent to Slack successfully");
    } catch (error) {
      logger.error("Failed to send daily summary:", error);
      throw error;
    }
  }

  /**
   * 週次サマリー（全アプリ合計）を送信
   */
  async sendWeeklySummary(summary: {
    startDate: string;
    endDate: string;
    appCount: number;
    totalActiveUsers: number;
    totalNewUsers: number;
    totalSessions: number;
  }): Promise<void> {
    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "divider",
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `📊　*Weekly Summary*　_${summary.startDate} 〜 ${summary.endDate}_　（${summary.appCount}アプリ）`,
          },
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: `👥 *合計WAU* ${summary.totalActiveUsers.toLocaleString()}　｜　🆕 *合計新規* ${summary.totalNewUsers.toLocaleString()}　｜　📱 *合計セッション* ${summary.totalSessions.toLocaleString()}`,
            },
          ],
        },
      ],
    };

    try {
      await this.webhook.send(message);
      logger.info("Weekly summary sent to Slack successfully");
    } catch (error) {
      logger.error("Failed to send weekly summary:", error);
      throw error;
    }
  }

  /**
   * 月次サマリー（全アプリ合計）を送信
   */
  async sendMonthlySummary(summary: {
    month: string;
    appCount: number;
    totalActiveUsers: number;
    totalNewUsers: number;
    totalSessions: number;
  }): Promise<void> {
    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "divider",
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `📊　*Monthly Summary*　_${summary.month}_　（${summary.appCount}アプリ）`,
          },
        },
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: `👥 *合計MAU* ${summary.totalActiveUsers.toLocaleString()}　｜　🆕 *合計新規* ${summary.totalNewUsers.toLocaleString()}　｜　📱 *合計セッション* ${summary.totalSessions.toLocaleString()}`,
            },
          ],
        },
      ],
    };

    try {
      await this.webhook.send(message);
      logger.info("Monthly summary sent to Slack successfully");
    } catch (error) {
      logger.error("Failed to send monthly summary:", error);
      throw error;
    }
  }

  /**
   * お問い合わせ通知を送信
   */
  async sendContactNotification(data: {
    id: string;
    name: string;
    email: string;
    category: string;
    message: string;
    language: string;
  }): Promise<void> {
    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "header",
          text: {
            type: "plain_text",
            text: "📬 新しいお問い合わせ",
            emoji: true,
          },
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `*🎯 アプリ:* \`${this.appName}\`\n*📋 ID:* \`${data.id}\``,
          },
        },
        {
          type: "section",
          fields: [
            {
              type: "mrkdwn",
              text: `*👤 名前:*\n${data.name}`,
            },
            {
              type: "mrkdwn",
              text: `*📧 メール:*\n${data.email}`,
            },
            {
              type: "mrkdwn",
              text: `*📁 カテゴリ:*\n${data.category}`,
            },
            {
              type: "mrkdwn",
              text: `*🌐 言語:*\n${data.language}`,
            },
          ],
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `*💬 メッセージ:*\n\`\`\`${data.message}\`\`\``,
          },
        },
      ],
    };

    try {
      await this.webhook.send(message);
      logger.info("Contact notification sent to Slack successfully");
    } catch (error) {
      logger.error("Failed to send contact notification:", error);
      throw error;
    }
  }

  /**
   * エラー通知を送信
   */
  async sendErrorNotification(errorMessage: string): Promise<void> {
    const message: IncomingWebhookSendArguments = {
      blocks: [
        {
          type: "header",
          text: {
            type: "plain_text",
            text: `⚠️ Metrics Error`,
            emoji: true,
          },
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: `*🎯 アプリ:* \`${this.appName}\`\n\n日次レポートの取得中にエラーが発生しました:\n\`\`\`${errorMessage}\`\`\``,
          },
        },
      ],
    };

    try {
      await this.webhook.send(message);
    } catch (error) {
      logger.error("Failed to send error notification:", error);
    }
  }

  /**
   * 変化率に応じた絵文字を取得
   */
  private getChangeEmoji(changePercent: number | undefined): string {
    if (changePercent === undefined) return "";
    if (changePercent >= 10) return "🚀";
    if (changePercent >= 5) return "📈";
    if (changePercent > 0) return "↗️";
    if (changePercent === 0) return "➡️";
    if (changePercent > -5) return "↘️";
    if (changePercent > -10) return "📉";
    return "🔻";
  }

  /**
   * 動的順位に応じたバッジを取得
   */
  private getRankBadge(rank: number): string {
    switch (rank) {
      case 1:
        return "🥇 *Rank 1*";
      case 2:
        return "🥈 *Rank 2*";
      case 3:
        return "🥉 *Rank 3*";
      default:
        return `#${rank}`;
    }
  }
}
