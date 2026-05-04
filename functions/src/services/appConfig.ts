import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

// Firebase Admin初期化（まだの場合）
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * アプリ設定の型定義
 */
export interface AppConfig {
  id: string;
  appName: string;
  appStoreAppId: string;
  analyticsPropertyId: string;
  admobAppId?: string; // AdMob App ID（オプション）
  enabled: boolean;
  priority: number; // 優先順位（小さいほど優先、Slack通知順序に使用）
}

/**
 * Firestoreからアプリ設定を管理するサービス
 */
export class AppConfigService {
  private collectionName = "metrics_apps";

  /**
   * 有効な全アプリ設定を取得
   */
  async getEnabledApps(): Promise<AppConfig[]> {
    try {
      // orderByを使わずに取得（priorityフィールドがないドキュメントも含める）
      const snapshot = await db
        .collection(this.collectionName)
        .where("enabled", "==", true)
        .get();

      if (snapshot.empty) {
        logger.warn("No enabled apps found in Firestore");
        return [];
      }

      const apps = snapshot.docs.map((doc) => ({
        id: doc.id,
        appName: doc.data().appName || "",
        appStoreAppId: doc.data().appStoreAppId || "",
        analyticsPropertyId: doc.data().analyticsPropertyId || "",
        admobAppId: doc.data().admobAppId || undefined,
        enabled: doc.data().enabled ?? true,
        priority: doc.data().priority ?? 999, // 未設定は999
      }));

      // priority昇順でソート
      return apps.sort((a, b) => a.priority - b.priority);
    } catch (error) {
      logger.error("Failed to get app configs:", error);
      throw error;
    }
  }

  /**
   * 特定のアプリ設定を取得
   */
  async getAppConfig(appId: string): Promise<AppConfig | null> {
    try {
      const doc = await db.collection(this.collectionName).doc(appId).get();

      if (!doc.exists) {
        return null;
      }

      const data = doc.data()!;
      return {
        id: doc.id,
        appName: data.appName || "",
        appStoreAppId: data.appStoreAppId || "",
        analyticsPropertyId: data.analyticsPropertyId || "",
        admobAppId: data.admobAppId || undefined,
        enabled: data.enabled ?? true,
        priority: data.priority ?? 999,
      };
    } catch (error) {
      logger.error(`Failed to get app config for ${appId}:`, error);
      throw error;
    }
  }

  /**
   * アプリ設定を追加/更新
   */
  async upsertAppConfig(
    appId: string,
    config: Omit<AppConfig, "id">
  ): Promise<void> {
    try {
      await db.collection(this.collectionName).doc(appId).set(config, { merge: true });
      logger.info(`App config updated: ${appId}`);
    } catch (error) {
      logger.error(`Failed to upsert app config for ${appId}:`, error);
      throw error;
    }
  }

  /**
   * アプリを無効化
   */
  async disableApp(appId: string): Promise<void> {
    try {
      await db.collection(this.collectionName).doc(appId).update({ enabled: false });
      logger.info(`App disabled: ${appId}`);
    } catch (error) {
      logger.error(`Failed to disable app ${appId}:`, error);
      throw error;
    }
  }
}
