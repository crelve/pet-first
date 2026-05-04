import * as logger from "firebase-functions/logger";

interface AdMobConfig {
  clientId: string;
  clientSecret: string;
  refreshToken: string;
  publisherId: string;
}

interface AdMobMetrics {
  date: string;
  estimatedEarnings: number; // 推定収益（USD）
  impressions: number;
  clicks: number;
  ecpm: number; // eCPM（1000インプレッションあたりの収益）
}

/**
 * AdMob API サービス
 * OAuth 2.0 リフレッシュトークンを使用して認証
 */
export class AdMobService {
  private config: AdMobConfig;
  private accessToken: string | null = null;

  constructor(config: AdMobConfig) {
    this.config = config;
  }

  /**
   * リフレッシュトークンからアクセストークンを取得
   */
  private async getAccessToken(): Promise<string> {
    if (this.accessToken) {
      return this.accessToken;
    }

    try {
      const response = await fetch("https://oauth2.googleapis.com/token", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
          client_id: this.config.clientId,
          client_secret: this.config.clientSecret,
          refresh_token: this.config.refreshToken,
          grant_type: "refresh_token",
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Token refresh failed: ${errorText}`);
      }

      const data = await response.json();
      const token = data.access_token as string;
      this.accessToken = token;
      return token;
    } catch (error) {
      logger.error("Failed to get AdMob access token:", error);
      throw error;
    }
  }

  /**
   * 昨日の収益メトリクスを取得
   */
  async getYesterdayMetrics(adUnitAppId?: string): Promise<AdMobMetrics> {
    const accessToken = await this.getAccessToken();
    const yesterday = this.getYesterdayDate();

    try {
      // AdMob Network Report API
      const reportUrl = `https://admob.googleapis.com/v1/accounts/${this.config.publisherId}/networkReport:generate`;

      const requestBody = {
        reportSpec: {
          dateRange: {
            startDate: { year: parseInt(yesterday.split("-")[0]), month: parseInt(yesterday.split("-")[1]), day: parseInt(yesterday.split("-")[2]) },
            endDate: { year: parseInt(yesterday.split("-")[0]), month: parseInt(yesterday.split("-")[1]), day: parseInt(yesterday.split("-")[2]) },
          },
          dimensions: ["DATE"],
          metrics: [
            "ESTIMATED_EARNINGS",
            "IMPRESSIONS",
            "CLICKS",
          ],
          // アプリでフィルタする場合
          ...(adUnitAppId && {
            dimensionFilters: [{
              dimension: "APP",
              matchesAny: { values: [adUnitAppId] },
            }],
          }),
        },
      };

      const response = await fetch(reportUrl, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        const errorText = await response.text();
        logger.error("AdMob API error:", {
          status: response.status,
          statusText: response.statusText,
          error: errorText,
        });
        throw new Error(`AdMob API error: ${response.status} ${errorText}`);
      }

      const data = await response.json();
      return this.parseReportResponse(data, yesterday);
    } catch (error) {
      logger.error("Failed to get AdMob metrics:", error);
      throw error;
    }
  }

  /**
   * アカウント全体の昨日の収益を取得
   */
  async getAccountMetrics(): Promise<AdMobMetrics> {
    return this.getYesterdayMetrics();
  }

  /**
   * レスポンスをパースしてメトリクスを抽出
   */
  private parseReportResponse(data: unknown, date: string): AdMobMetrics {
    // AdMob APIのレスポンスは配列形式
    // [{ header: {...} }, { row: {...} }, { footer: {...} }]
    const responseArray = data as Array<{
      header?: { localizationSettings?: { currencyCode?: string } };
      row?: {
        metricValues?: {
          ESTIMATED_EARNINGS?: { microsValue?: string };
          IMPRESSIONS?: { integerValue?: string };
          CLICKS?: { integerValue?: string };
        };
      };
    }>;

    let estimatedEarnings = 0;
    let impressions = 0;
    let clicks = 0;

    for (const item of responseArray) {
      if (item.row?.metricValues) {
        const metrics = item.row.metricValues;
        // ESTIMATED_EARNINGS は micros 単位（1,000,000 micros = 1 通貨単位）
        // 日本円の場合も同じ計算
        if (metrics.ESTIMATED_EARNINGS?.microsValue) {
          estimatedEarnings += parseInt(metrics.ESTIMATED_EARNINGS.microsValue) / 1000000;
        }
        if (metrics.IMPRESSIONS?.integerValue) {
          impressions += parseInt(metrics.IMPRESSIONS.integerValue);
        }
        if (metrics.CLICKS?.integerValue) {
          clicks += parseInt(metrics.CLICKS.integerValue);
        }
      }
    }

    const ecpm = impressions > 0 ? (estimatedEarnings / impressions) * 1000 : 0;

    return {
      date,
      estimatedEarnings: Math.round(estimatedEarnings * 100) / 100, // 小数点2桁
      impressions,
      clicks,
      ecpm: Math.round(ecpm * 100) / 100,
    };
  }

  /**
   * 昨日の日付を YYYY-MM-DD 形式で取得
   */
  private getYesterdayDate(): string {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    return yesterday.toISOString().split("T")[0];
  }
}
