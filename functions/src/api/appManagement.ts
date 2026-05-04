import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { AppConfigService } from "../services/appConfig";

const appConfigService = new AppConfigService();

/**
 * アプリ設定を追加/更新するAPI
 * POST /addApp
 * Body: { appId, appName, appStoreAppId, analyticsPropertyId }
 */
export const addApp = onRequest(
  {
    cors: true,
    memory: "256MiB",
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    try {
      const { appId, appName, appStoreAppId, analyticsPropertyId, priority } = req.body;

      if (!appId || !appName || !appStoreAppId || !analyticsPropertyId) {
        res.status(400).json({
          error: "Missing required fields",
          required: ["appId", "appName", "appStoreAppId", "analyticsPropertyId"],
          optional: ["priority"],
        });
        return;
      }

      await appConfigService.upsertAppConfig(appId, {
        appName,
        appStoreAppId,
        analyticsPropertyId,
        enabled: true,
        priority: priority ?? 999, // デフォルト優先度
      });

      logger.info(`App added/updated: ${appId}`);
      res.status(200).json({
        success: true,
        message: `App "${appName}" has been registered`,
        appId,
      });
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : "Unknown error";
      logger.error("Failed to add app:", error);
      res.status(500).json({ error: errorMessage });
    }
  }
);

/**
 * 登録済みアプリ一覧を取得するAPI
 * GET /listApps
 */
export const listApps = onRequest(
  {
    cors: true,
    memory: "256MiB",
  },
  async (req, res) => {
    if (req.method !== "GET") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    try {
      const apps = await appConfigService.getEnabledApps();
      res.status(200).json({
        success: true,
        count: apps.length,
        apps,
      });
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : "Unknown error";
      logger.error("Failed to list apps:", error);
      res.status(500).json({ error: errorMessage });
    }
  }
);
