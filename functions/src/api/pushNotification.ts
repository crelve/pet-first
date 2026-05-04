import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";

/**
 * FCMを使って指定トークンにプッシュ通知を送信するCallable Function
 *
 * @param data.title 通知タイトル
 * @param data.body  通知本文
 * @param data.token 送信先FCMトークン
 */
export const sendPushNotification = onCall(
  { region: "asia-northeast1" },
  async (request) => {
    const { title, body, token } = request.data as {
      title: string;
      body: string;
      token: string;
    };

    if (!title || !body || !token) {
      throw new HttpsError(
        "invalid-argument",
        "title, body, token are required"
      );
    }

    try {
      const messageId = await admin.messaging().send({
        notification: { title, body },
        token,
      });
      return { success: true, messageId };
    } catch (error) {
      throw new HttpsError("internal", String(error));
    }
  }
);

/**
 * テスト用Push通知送信（後方互換のため残す）
 *
 * @deprecated sendPushNotification を使用してください
 */
export const pushTest = onCall(
  { region: "asia-northeast1" },
  async (request) => {
    const { title, body, token } = request.data as {
      title: string;
      body: string;
      token: string;
    };

    if (!title || !body || !token) {
      throw new HttpsError(
        "invalid-argument",
        "title, body, token are required"
      );
    }

    try {
      const messageId = await admin.messaging().send({
        notification: { title, body },
        token,
      });
      return { success: true, messageId };
    } catch (error) {
      throw new HttpsError("internal", String(error));
    }
  }
);
