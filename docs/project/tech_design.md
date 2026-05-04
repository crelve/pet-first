# Pet First 技術設計

## アーキテクチャ概要

```
┌─────────────────────────────────────┐
│   Presentation Layer (Flutter)      │
│   - Riverpod + Flutter Hooks        │
│   - GoRouter                         │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│   Domain Layer                       │
│   - Symptom Entity                   │
│   - EmergencyLevel (red/yellow/green)│
│   - FirstAidStep                     │
└─────────────┬───────────────────────┘
              │
┌─────────────▼───────────────────────┐
│   Data Layer                         │
│   - SymptomRepository (Hive local)   │
│   - PetProfileRepository (Hive)      │
│   - Firebase (Analytics/Crashlytics) │
└──────────────────────────────────────┘
```

## 技術スタック

| レイヤー | 技術 | 理由 |
|---------|------|------|
| UI | Flutter 3.24+ / flutter_foundation | 共通基盤活用90% |
| 状態管理 | Riverpod 3.0 + flutter_hooks | 全アプリ共通 |
| ルーティング | go_router 17 | 全アプリ共通 |
| ローカルDB | Hive | オフライン要件 |
| 多言語 | Flutter Intl（39言語） | 全アプリ共通 |
| 課金 | RevenueCat | 全アプリ共通 |
| 広告 | AdMob | 全アプリ共通 |
| Backend | Firebase | Hosting/FCM/Analytics/Crashlytics/Functions |

## Firebase構成（必須）

| サービス | 用途 |
|---------|------|
| Firebase Hosting | ランディングページ、プライバシーポリシー、利用規約 |
| Firebase Authentication | 匿名認証（プロフィール同期用 P1） |
| Cloud Firestore | プロフィール同期（P1） |
| Firebase Analytics | DAU/MAU、ファネル計測 |
| Firebase Crashlytics | 障害監視 |
| Cloud Functions | RevenueCat Webhook処理 |
| FCM | 月次健康通知 |
| App Check | API保護 |

※ Firebase prodプロジェクトのみ作成（dev禁止：CEO指示）

## データモデル

### Symptom

```dart
class Symptom {
  final String id;
  final PetType petType;        // dog | cat
  final String category;         // 嘔吐 / 痙攣 / 誤飲 / etc
  final String title;
  final String description;
  final EmergencyLevel level;    // red | yellow | green
  final List<FirstAidStep> steps;
  final List<String> warnings;   // NG行為
  final List<String> seeVetIf;   // すぐ病院に行くべき症状
}

enum PetType { dog, cat }
enum EmergencyLevel { red, yellow, green }
```

### FirstAidStep

```dart
class FirstAidStep {
  final int order;
  final String instruction;
  final String? imageAsset;
  final bool isWarning;   // NG行為かどうか
}
```

### PetProfile (P1)

```dart
class PetProfile {
  final String id;
  final String name;
  final PetType type;
  final String breed;
  final DateTime birthDate;
  final double weightKg;
  final List<String> allergies;
  final List<String> medications;
  final List<String> medicalHistory;
}
```

## オフライン戦略（要件）

- 症状DB: アプリバンドル時にJSON/Hive初期化
- 画像: assetsフォルダにバンドル
- 画像最適化: WebP形式、サイズ300KB以下/枚
- 想定アプリサイズ: 50MB以下（症状画像30+ × 300KB ≈ 9MB + 基盤）

## セキュリティ

| 項目 | 対策 |
|------|------|
| API保護 | Firebase App Check（DeviceCheck/PlayIntegrity） |
| 個人情報 | ペットプロフィールはローカルのみ（P1で同期は匿名認証） |
| Privacy Manifest | 必須対応（Apple 2024要件） |
| プライバシーポリシー | Firebase Hosting配信 |

## 計測設計

| イベント | 用途 |
|---------|------|
| `symptom_viewed` | どの症状が頻繁か |
| `emergency_level_distribution` | 赤/黄/緑の分布 |
| `paywall_shown` | ペイウォール表示回数 |
| `paywall_converted` | 課金成立 |
| `pet_type_selected` | 犬/猫比率 |

## AI使用

**なし**（M5の同意画面は不要）

症状DBは医療情報を静的にバンドル。AI推論は使用しない。
