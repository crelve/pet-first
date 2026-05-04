import * as jwt from "jsonwebtoken";
import * as logger from "firebase-functions/logger";

interface AppStoreConnectConfig {
  issuerId: string;
  keyId: string;
  privateKey: string;
  vendorNumber: string;
  appId: string;
}

interface DownloadMetrics {
  date: string;
  downloads: number;
  redownloads: number;
  totalDownloads: number;
}

/**
 * App Store Connect APIクライアント
 * Sales and Trends APIを使用してダウンロード数を取得
 */
export class AppStoreConnectService {
  private config: AppStoreConnectConfig;

  constructor(config: AppStoreConnectConfig) {
    this.config = config;
  }

  /**
   * JWT認証トークンを生成
   */
  private generateToken(): string {
    const now = Math.floor(Date.now() / 1000);
    const payload = {
      iss: this.config.issuerId,
      iat: now,
      exp: now + 20 * 60, // 20分有効
      aud: "appstoreconnect-v1",
    };

    // \n を実際の改行に変換
    const privateKey = this.config.privateKey.replace(/\\n/g, "\n");

    return jwt.sign(payload, privateKey, {
      algorithm: "ES256",
      header: {
        alg: "ES256",
        kid: this.config.keyId,
        typ: "JWT",
      },
    });
  }

  /**
   * 昨日のダウンロード数を取得
   */
  async getYesterdayDownloads(): Promise<DownloadMetrics> {
    const token = this.generateToken();
    const yesterday = this.getYesterdayDate();

    try {
      // Sales and Trends API - SALES レポート取得
      const reportUrl = new URL(
        "https://api.appstoreconnect.apple.com/v1/salesReports"
      );
      reportUrl.searchParams.append("filter[frequency]", "DAILY");
      reportUrl.searchParams.append("filter[reportDate]", yesterday);
      reportUrl.searchParams.append("filter[reportSubType]", "SUMMARY");
      reportUrl.searchParams.append("filter[reportType]", "SALES");
      reportUrl.searchParams.append("filter[vendorNumber]", this.config.vendorNumber);

      const response = await fetch(reportUrl.toString(), {
        method: "GET",
        headers: {
          Authorization: `Bearer ${token}`,
          Accept: "application/a-gzip",
        },
      });

      if (!response.ok) {
        const errorText = await response.text();
        logger.error("App Store Connect API error:", {
          status: response.status,
          statusText: response.statusText,
          body: errorText,
        });

        // レポートがまだ準備できていない場合（通常2-3日遅れ）
        if (response.status === 404) {
          logger.warn(`Report for ${yesterday} not available yet`);
          return {
            date: yesterday,
            downloads: 0,
            redownloads: 0,
            totalDownloads: 0,
          };
        }

        throw new Error(`API error: ${response.status} ${response.statusText}`);
      }

      // gzip圧縮されたTSVデータをパース
      const data = await this.parseGzipResponse(response);
      return this.parseDownloadReport(data, yesterday);
    } catch (error) {
      logger.error("Failed to get downloads:", error);
      throw error;
    }
  }

  /**
   * Analytics APIでアプリのインストール数を取得（リアルタイム性が高い）
   */
  async getAnalyticsInstalls(): Promise<DownloadMetrics> {
    const token = this.generateToken();
    const yesterday = this.getYesterdayDate();

    try {
      // App Analytics API
      const analyticsUrl = `https://api.appstoreconnect.apple.com/v1/apps/${this.config.appId}/analyticsReportRequests`;

      // まずレポートリクエストを作成
      const requestBody = {
        data: {
          type: "analyticsReportRequests",
          attributes: {
            accessType: "ONGOING",
          },
          relationships: {
            app: {
              data: {
                type: "apps",
                id: this.config.appId,
              },
            },
          },
        },
      };

      const createResponse = await fetch(analyticsUrl, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestBody),
      });

      if (!createResponse.ok) {
        // 既存のレポートがある場合は取得を試みる
        return await this.getExistingAnalyticsReport(token, yesterday);
      }

      // レポートの準備を待って取得
      return await this.getExistingAnalyticsReport(token, yesterday);
    } catch (error) {
      logger.error("Failed to get analytics installs:", error);
      return {
        date: yesterday,
        downloads: 0,
        redownloads: 0,
        totalDownloads: 0,
      };
    }
  }

  /**
   * 既存のAnalyticsレポートを取得
   */
  private async getExistingAnalyticsReport(
    token: string,
    date: string
  ): Promise<DownloadMetrics> {
    try {
      const reportsUrl = `https://api.appstoreconnect.apple.com/v1/apps/${this.config.appId}/analyticsReportRequests`;

      const response = await fetch(reportsUrl, {
        method: "GET",
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to get analytics reports: ${response.status}`);
      }

      const data = await response.json();
      logger.info("Analytics reports:", JSON.stringify(data));

      // レポートデータをパース（実際の構造に応じて調整）
      return {
        date: date,
        downloads: 0,
        redownloads: 0,
        totalDownloads: 0,
      };
    } catch (error) {
      logger.error("Failed to get existing analytics report:", error);
      return {
        date: date,
        downloads: 0,
        redownloads: 0,
        totalDownloads: 0,
      };
    }
  }

  /**
   * gzip圧縮されたレスポンスをパース
   */
  private async parseGzipResponse(response: Response): Promise<string> {
    const buffer = await response.arrayBuffer();

    // Node.js環境でgzip解凍
    const zlib = await import("zlib");
    const { promisify } = await import("util");
    const gunzip = promisify(zlib.gunzip);

    const uint8Array = new Uint8Array(buffer);
    const decompressed = await gunzip(uint8Array as Parameters<typeof gunzip>[0]);
    return decompressed.toString("utf-8");
  }

  /**
   * TSVレポートをパースしてダウンロード数を抽出
   */
  private parseDownloadReport(tsvData: string, date: string): DownloadMetrics {
    const lines = tsvData.trim().split("\n");
    if (lines.length < 2) {
      return {
        date,
        downloads: 0,
        redownloads: 0,
        totalDownloads: 0,
      };
    }

    const headers = lines[0].split("\t");
    const unitsIndex = headers.findIndex((h) => h === "Units");
    const productTypeIndex = headers.findIndex(
      (h) => h === "Product Type Identifier"
    );

    let downloads = 0;
    let redownloads = 0;

    for (let i = 1; i < lines.length; i++) {
      const values = lines[i].split("\t");
      const units = parseInt(values[unitsIndex] || "0", 10);
      const productType = values[productTypeIndex] || "";

      // 1F = iPhone App (新規), 1T = iPhone App (再ダウンロード)
      // 7F = iPad App (新規), 7T = iPad App (再ダウンロード)
      if (productType.endsWith("F")) {
        downloads += units;
      } else if (productType.endsWith("T")) {
        redownloads += units;
      }
    }

    return {
      date,
      downloads,
      redownloads,
      totalDownloads: downloads + redownloads,
    };
  }

  /**
   * 昨日の日付を YYYY-MM-DD 形式で取得
   */
  private getYesterdayDate(): string {
    return this.getDateDaysAgo(1);
  }

  /**
   * N日前の日付を YYYY-MM-DD 形式で取得
   */
  private getDateDaysAgo(days: number): string {
    const date = new Date();
    date.setDate(date.getDate() - days);
    return date.toISOString().split("T")[0];
  }
}
