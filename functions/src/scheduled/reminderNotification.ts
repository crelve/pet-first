import * as admin from "firebase-admin";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/v2";

/**
 * Firestoreに保存されたリマインダーを1分ごとにチェックし、
 * 送信時刻を過ぎたものをFCMでプッシュ通知として配信する。
 *
 * Firestoreコレクション: reminders
 * ドキュメント構造:
 *   - userId: string       ユーザーID
 *   - title: string        通知タイトル
 *   - body: string         通知本文
 *   - scheduledAt: Timestamp 送信予定日時
 *   - fcmToken: string     送信先FCMトークン
 *   - isSent: boolean      送信済みフラグ
 *   - isActive: boolean    有効フラグ（キャンセル時はfalse）
 *   - createdAt: Timestamp 作成日時
 */
export const processReminders = onSchedule(
  {
    schedule: "every 1 minutes",
    region: "asia-northeast1",
    timeZone: "Asia/Tokyo",
  },
  async () => {
    const db = admin.firestore();
    const now = admin.firestore.Timestamp.now();

    const snapshot = await db
      .collection("reminders")
      .where("scheduledAt", "<=", now)
      .where("isSent", "==", false)
      .where("isActive", "==", true)
      .get();

    if (snapshot.empty) {
      return;
    }

    const batch = db.batch();
    const sendPromises: Promise<string>[] = [];

    snapshot.forEach((doc) => {
      const reminder = doc.data();
      if (!reminder.fcmToken) {
        logger.warn(`Reminder ${doc.id} has no fcmToken, skipping`);
        batch.update(doc.ref, { isSent: true });
        return;
      }

      sendPromises.push(
        admin.messaging().send({
          notification: {
            title: reminder.title as string,
            body: reminder.body as string,
          },
          token: reminder.fcmToken as string,
          data: {
            reminderId: doc.id,
            userId: reminder.userId as string,
          },
        })
      );

      batch.update(doc.ref, {
        isSent: true,
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    const results = await Promise.allSettled(sendPromises);
    results.forEach((result, index) => {
      if (result.status === "rejected") {
        logger.error(`Failed to send reminder at index ${index}:`, result.reason);
      }
    });

    await batch.commit();
    logger.info(`Processed ${snapshot.size} reminders`);
  }
);
