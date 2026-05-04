/**
 * Cloud Functions for Firebase
 *
 * メトリクスレポート機能:
 * - Firestoreに登録された全アプリのメトリクスを取得
 * - App Store Connect API でDL数を取得
 * - Firebase Analytics Data API でDAUを取得
 * - Slack Webhook でレポートを送信
 *
 * スケジュール:
 * - 日次: 毎日 AM 9:00 (JST)
 * - 週次: 毎週月曜日 AM 9:00 (JST)
 * - 月次: 毎月1日 AM 9:00 (JST)
 *
 * Push通知・リマインダー機能:
 * - sendPushNotification: FCMで個別プッシュ通知を送信するCallable Function
 * - pushTest: テスト用Push通知（後方互換）
 * - processReminders: Firestoreのリマインダーを1分毎にチェックして通知送信
 */

// Scheduled Functions
export { dailyMetricsReport } from "./scheduled/dailyMetricsReport";
export { weeklyMetricsReport } from "./scheduled/weeklyMetricsReport";
export { monthlyMetricsReport } from "./scheduled/monthlyMetricsReport";
export { processReminders } from "./scheduled/reminderNotification";

// HTTP API
export { addApp, listApps } from "./api/appManagement";
export { getMetrics, getMetricsSummary, getDAUTrend } from "./api/metricsApi";

// Contact Form API
export {
  submitContactForm,
  listContactForms,
  updateContactFormStatus,
} from "./api/contactForm";

// Push Notification API
export { sendPushNotification, pushTest } from "./api/pushNotification";
