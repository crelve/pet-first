import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_foundation/flutter_foundation.dart';

import '../model/reminder.dart';

/// リマインダー通知サービス
///
/// Firestoreにリマインダーを保存し、Cloud Functions の processReminders が
/// スケジュール時刻にFCMで通知を送信する。
///
/// Push通知の受信基盤（FCMトークン管理・通知許可・受信ハンドラ）は
/// flutter_foundation の `PushNotificationStateNotifier` / `handleCloudMessage` が担う。
/// このサービスは「送信スケジュール（Firestore保存）」に特化する。
///
/// 使用例:
/// ```dart
/// // FCMトークンは flutter_foundation から取得して渡す
/// final fcmToken = ref.read(pushNotificationStateNotifierProvider).token;
/// final service = ReminderNotificationService();
///
/// // リマインダーを登録
/// final id = await service.scheduleReminder(
///   userId: 'user123',
///   title: '薬を飲む時間です',
///   body: '毎朝8時のリマインダー',
///   scheduledAt: DateTime.now().add(const Duration(hours: 1)),
///   fcmToken: fcmToken,
/// );
///
/// // リマインダー一覧を監視
/// service.watchReminders('user123').listen((reminders) {
///   // UIを更新
/// });
///
/// // リマインダーをキャンセル
/// await service.cancelReminder(id);
/// ```
class ReminderNotificationService {
  /// Creates a [ReminderNotificationService] instance.
  ReminderNotificationService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'reminders';

  final FirebaseFirestore _firestore;

  /// リマインダーをFirestoreに保存して予約送信を登録する
  ///
  /// [userId]      ユーザーID（Firestoreのドキュメント検索に使用）
  /// [title]       通知タイトル
  /// [body]        通知本文
  /// [scheduledAt] 送信予定日時（現在時刻より未来である必要がある）
  /// [fcmToken]    FCMトークン —
  ///               `ref.read(pushNotificationStateNotifierProvider).token`
  ///               を渡すこと
  ///
  /// Returns: 作成されたリマインダーのドキュメントID
  Future<String> scheduleReminder({
    required String userId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String? fcmToken,
  }) async {
    assert(
      scheduledAt.isAfter(DateTime.now()),
      'scheduledAt must be in the future',
    );

    final docRef = await _firestore.collection(_collection).add({
      'userId': userId,
      'title': title,
      'body': body,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'isSent': false,
      'isActive': true,
      'fcmToken': fcmToken,
      'createdAt': FieldValue.serverTimestamp(),
    });

    logger.d('Reminder scheduled: ${docRef.id} at $scheduledAt');
    return docRef.id;
  }

  /// 指定ユーザーのアクティブなリマインダー一覧をリアルタイム監視する
  ///
  /// 未送信・有効なリマインダーを送信予定日時の昇順で返す
  Stream<List<Reminder>> watchReminders(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('scheduledAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Reminder.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  /// 指定ユーザーのリマインダーを1件取得する
  Future<Reminder?> getReminder(String reminderId) async {
    final doc = await _firestore.collection(_collection).doc(reminderId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Reminder.fromFirestore(doc.data()!, doc.id);
  }

  /// リマインダーをキャンセルする（isActive を false に設定）
  ///
  /// Cloud Functions の processReminders はキャンセルされたリマインダーをスキップする
  Future<void> cancelReminder(String reminderId) async {
    await _firestore.collection(_collection).doc(reminderId).update({
      'isActive': false,
    });
    logger.d('Reminder cancelled: $reminderId');
  }

  /// FCMトークンが変更された場合に全アクティブリマインダーを更新する
  ///
  /// `PushNotificationStateNotifier` のトークン更新を検知した際に呼び出すこと。
  /// トークンは呼び出し側で
  /// `ref.read(pushNotificationStateNotifierProvider).token`
  /// から取得すること。
  Future<void> refreshFcmToken(String userId, String newToken) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .where('isSent', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'fcmToken': newToken});
    }
    await batch.commit();
    logger.d('FCM token refreshed for ${snapshot.size} reminders');
  }
}
