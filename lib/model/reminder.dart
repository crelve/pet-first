import 'package:cloud_firestore/cloud_firestore.dart';

/// リマインダー通知モデル
///
/// Firestoreコレクション: reminders
class Reminder {
  /// Creates a [Reminder] instance.
  const Reminder({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.scheduledAt,
    required this.isSent,
    required this.isActive,
    this.fcmToken,
    this.sentAt,
    this.createdAt,
  });

  /// Firestoreドキュメントから [Reminder] を生成する
  factory Reminder.fromFirestore(Map<String, dynamic> data, String id) {
    return Reminder(
      id: id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      scheduledAt: (data['scheduledAt'] as Timestamp).toDate(),
      isSent: data['isSent'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      fcmToken: data['fcmToken'] as String?,
      sentAt: (data['sentAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Firestoreドキュメントのドキュメントid
  final String id;

  /// リマインダーを所有するユーザーのid
  final String userId;

  /// 通知タイトル
  final String title;

  /// 通知本文
  final String body;

  /// 送信予定日時
  final DateTime scheduledAt;

  /// 送信済みフラグ
  final bool isSent;

  /// 有効フラグ（キャンセル時は false）
  final bool isActive;

  /// 送信先FCMトークン
  final String? fcmToken;

  /// 実際に送信された日時
  final DateTime? sentAt;

  /// ドキュメント作成日時
  final DateTime? createdAt;

  /// Firestore保存用のMapに変換する
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'isSent': isSent,
      'isActive': isActive,
      'fcmToken': fcmToken,
    };
  }

  /// 指定フィールドを変更した新しいインスタンスを返す
  Reminder copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    DateTime? scheduledAt,
    bool? isSent,
    bool? isActive,
    String? fcmToken,
    DateTime? sentAt,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isSent: isSent ?? this.isSent,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
