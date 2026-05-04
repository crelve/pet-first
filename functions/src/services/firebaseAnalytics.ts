import { BetaAnalyticsDataClient } from "@google-analytics/data";
import * as logger from "firebase-functions/logger";

interface AnalyticsMetrics {
  date: string;
  activeUsers: number;
  newUsers: number;
  sessions: number;
  screenPageViews: number;
}

/**
 * Firebase Analytics Data API サービス
 * Google Analytics 4 (GA4) Data API を使用
 */
export class FirebaseAnalyticsService {
  private client: BetaAnalyticsDataClient;
  private propertyId: string;

  constructor(propertyId: string) {
    // Application Default Credentials を使用
    this.client = new BetaAnalyticsDataClient();
    this.propertyId = propertyId;
  }

  /**
   * 昨日のDAU（Daily Active Users）を取得
   */
  async getYesterdayMetrics(): Promise<AnalyticsMetrics> {
    const yesterday = this.getYesterdayDate();

    try {
      const [response] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [
          {
            startDate: yesterday,
            endDate: yesterday,
          },
        ],
        metrics: [
          { name: "activeUsers" },
          { name: "newUsers" },
          { name: "sessions" },
          { name: "screenPageViews" },
        ],
      });

      if (!response.rows || response.rows.length === 0) {
        logger.warn(`No analytics data for ${yesterday}`);
        return {
          date: yesterday,
          activeUsers: 0,
          newUsers: 0,
          sessions: 0,
          screenPageViews: 0,
        };
      }

      const row = response.rows[0];
      const metricValues = row.metricValues || [];

      return {
        date: yesterday,
        activeUsers: parseInt(metricValues[0]?.value || "0", 10),
        newUsers: parseInt(metricValues[1]?.value || "0", 10),
        sessions: parseInt(metricValues[2]?.value || "0", 10),
        screenPageViews: parseInt(metricValues[3]?.value || "0", 10),
      };
    } catch (error) {
      logger.error("Failed to get analytics metrics:", error);
      throw error;
    }
  }

  /**
   * 過去N日間のDAU推移を取得
   */
  async getDAUTrend(days: number = 7): Promise<AnalyticsMetrics[]> {
    const endDate = this.getYesterdayDate();
    const startDate = this.getDateDaysAgo(days);

    try {
      const [response] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [
          {
            startDate: startDate,
            endDate: endDate,
          },
        ],
        dimensions: [{ name: "date" }],
        metrics: [
          { name: "activeUsers" },
          { name: "newUsers" },
          { name: "sessions" },
          { name: "screenPageViews" },
        ],
        orderBys: [
          {
            dimension: { dimensionName: "date" },
            desc: false,
          },
        ],
      });

      if (!response.rows) {
        return [];
      }

      return response.rows.map((row) => {
        const date = row.dimensionValues?.[0]?.value || "";
        const metricValues = row.metricValues || [];

        return {
          date: this.formatDateString(date),
          activeUsers: parseInt(metricValues[0]?.value || "0", 10),
          newUsers: parseInt(metricValues[1]?.value || "0", 10),
          sessions: parseInt(metricValues[2]?.value || "0", 10),
          screenPageViews: parseInt(metricValues[3]?.value || "0", 10),
        };
      });
    } catch (error) {
      logger.error("Failed to get DAU trend:", error);
      throw error;
    }
  }

  /**
   * 週次比較データを取得（今週 vs 先週）
   */
  async getWeeklyComparison(): Promise<{
    thisWeek: AnalyticsMetrics;
    lastWeek: AnalyticsMetrics;
    changePercent: number;
  }> {
    const yesterday = this.getYesterdayDate();
    const weekAgo = this.getDateDaysAgo(7);
    const twoWeeksAgo = this.getDateDaysAgo(14);
    const eightDaysAgo = this.getDateDaysAgo(8);

    try {
      // 今週のデータ
      const [thisWeekResponse] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [
          {
            startDate: weekAgo,
            endDate: yesterday,
          },
        ],
        metrics: [
          { name: "activeUsers" },
          { name: "newUsers" },
          { name: "sessions" },
          { name: "screenPageViews" },
        ],
      });

      // 先週のデータ
      const [lastWeekResponse] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [
          {
            startDate: twoWeeksAgo,
            endDate: eightDaysAgo,
          },
        ],
        metrics: [
          { name: "activeUsers" },
          { name: "newUsers" },
          { name: "sessions" },
          { name: "screenPageViews" },
        ],
      });

      const thisWeek = this.parseMetricsResponse(thisWeekResponse, "this_week");
      const lastWeek = this.parseMetricsResponse(lastWeekResponse, "last_week");

      const changePercent =
        lastWeek.activeUsers > 0
          ? ((thisWeek.activeUsers - lastWeek.activeUsers) /
              lastWeek.activeUsers) *
            100
          : 0;

      return {
        thisWeek,
        lastWeek,
        changePercent: Math.round(changePercent * 10) / 10,
      };
    } catch (error) {
      logger.error("Failed to get weekly comparison:", error);
      throw error;
    }
  }

  /**
   * 週次サマリーを取得（過去7日間の合計）
   */
  async getWeeklySummary(): Promise<{
    startDate: string;
    endDate: string;
    totalActiveUsers: number;
    totalNewUsers: number;
    totalSessions: number;
    avgDailyActiveUsers: number;
    previousWeekComparison: number;
  }> {
    const endDate = this.getYesterdayDate();
    const startDate = this.getDateDaysAgo(7);
    const prevEndDate = this.getDateDaysAgo(8);
    const prevStartDate = this.getDateDaysAgo(14);

    try {
      // 今週のデータ
      const [thisWeekResponse] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [{ startDate, endDate }],
        metrics: [
          { name: "activeUsers" },
          { name: "newUsers" },
          { name: "sessions" },
        ],
      });

      // 先週のデータ
      const [lastWeekResponse] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [{ startDate: prevStartDate, endDate: prevEndDate }],
        metrics: [{ name: "activeUsers" }],
      });

      const thisWeekMetrics = thisWeekResponse.rows?.[0]?.metricValues || [];
      const lastWeekMetrics = lastWeekResponse.rows?.[0]?.metricValues || [];

      const totalActiveUsers = parseInt(thisWeekMetrics[0]?.value || "0", 10);
      const lastWeekActiveUsers = parseInt(lastWeekMetrics[0]?.value || "0", 10);

      const changePercent = lastWeekActiveUsers > 0
        ? ((totalActiveUsers - lastWeekActiveUsers) / lastWeekActiveUsers) * 100
        : 0;

      return {
        startDate,
        endDate,
        totalActiveUsers,
        totalNewUsers: parseInt(thisWeekMetrics[1]?.value || "0", 10),
        totalSessions: parseInt(thisWeekMetrics[2]?.value || "0", 10),
        avgDailyActiveUsers: Math.round(totalActiveUsers / 7),
        previousWeekComparison: Math.round(changePercent * 10) / 10,
      };
    } catch (error) {
      logger.error("Failed to get weekly summary:", error);
      throw error;
    }
  }

  /**
   * 月次サマリーを取得（前月の合計）
   */
  async getMonthlySummary(): Promise<{
    month: string;
    startDate: string;
    endDate: string;
    totalActiveUsers: number;
    totalNewUsers: number;
    totalSessions: number;
    avgDailyActiveUsers: number;
    previousMonthComparison: number;
  }> {
    // 前月の期間を計算
    const now = new Date();
    const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
    const lastMonthEnd = new Date(now.getFullYear(), now.getMonth(), 0);
    const prevMonth = new Date(now.getFullYear(), now.getMonth() - 2, 1);
    const prevMonthEnd = new Date(now.getFullYear(), now.getMonth() - 1, 0);

    const startDate = lastMonth.toISOString().split("T")[0];
    const endDate = lastMonthEnd.toISOString().split("T")[0];
    const prevStartDate = prevMonth.toISOString().split("T")[0];
    const prevEndDate = prevMonthEnd.toISOString().split("T")[0];

    const daysInMonth = lastMonthEnd.getDate();
    const monthStr = `${lastMonth.getFullYear()}-${String(lastMonth.getMonth() + 1).padStart(2, "0")}`;

    try {
      // 前月のデータ
      const [thisMonthResponse] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [{ startDate, endDate }],
        metrics: [
          { name: "activeUsers" },
          { name: "newUsers" },
          { name: "sessions" },
        ],
      });

      // 前々月のデータ
      const [lastMonthResponse] = await this.client.runReport({
        property: `properties/${this.propertyId}`,
        dateRanges: [{ startDate: prevStartDate, endDate: prevEndDate }],
        metrics: [{ name: "activeUsers" }],
      });

      const thisMonthMetrics = thisMonthResponse.rows?.[0]?.metricValues || [];
      const lastMonthMetrics = lastMonthResponse.rows?.[0]?.metricValues || [];

      const totalActiveUsers = parseInt(thisMonthMetrics[0]?.value || "0", 10);
      const prevMonthActiveUsers = parseInt(lastMonthMetrics[0]?.value || "0", 10);

      const changePercent = prevMonthActiveUsers > 0
        ? ((totalActiveUsers - prevMonthActiveUsers) / prevMonthActiveUsers) * 100
        : 0;

      return {
        month: monthStr,
        startDate,
        endDate,
        totalActiveUsers,
        totalNewUsers: parseInt(thisMonthMetrics[1]?.value || "0", 10),
        totalSessions: parseInt(thisMonthMetrics[2]?.value || "0", 10),
        avgDailyActiveUsers: Math.round(totalActiveUsers / daysInMonth),
        previousMonthComparison: Math.round(changePercent * 10) / 10,
      };
    } catch (error) {
      logger.error("Failed to get monthly summary:", error);
      throw error;
    }
  }

  private parseMetricsResponse(
    response: any,
    dateLabel: string
  ): AnalyticsMetrics {
    if (!response.rows || response.rows.length === 0) {
      return {
        date: dateLabel,
        activeUsers: 0,
        newUsers: 0,
        sessions: 0,
        screenPageViews: 0,
      };
    }

    const metricValues = response.rows[0].metricValues || [];

    return {
      date: dateLabel,
      activeUsers: parseInt(metricValues[0]?.value || "0", 10),
      newUsers: parseInt(metricValues[1]?.value || "0", 10),
      sessions: parseInt(metricValues[2]?.value || "0", 10),
      screenPageViews: parseInt(metricValues[3]?.value || "0", 10),
    };
  }

  private getYesterdayDate(): string {
    return this.getDateDaysAgo(1);
  }

  private getDateDaysAgo(days: number): string {
    const date = new Date();
    date.setDate(date.getDate() - days);
    return date.toISOString().split("T")[0];
  }

  private formatDateString(dateStr: string): string {
    // YYYYMMDD -> YYYY-MM-DD
    if (dateStr.length === 8) {
      return `${dateStr.slice(0, 4)}-${dateStr.slice(4, 6)}-${dateStr.slice(6, 8)}`;
    }
    return dateStr;
  }
}
