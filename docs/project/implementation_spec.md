# 実装仕様 — Pet First

## ファイル構成

```
lib/
├── screen/
│   ├── base_screen.dart                # ボトムナビ + AdBanner
│   ├── splash/splash_screen.dart
│   ├── onboarding/onboarding_screen.dart
│   ├── home/
│   │   ├── home_screen.dart            # 犬/猫タブ + カテゴリグリッド
│   │   └── home_provider.dart
│   ├── symptom_list/
│   │   ├── symptom_list_screen.dart    # カテゴリ内の症状リスト
│   │   └── symptom_list_provider.dart
│   ├── symptom_detail/
│   │   ├── symptom_detail_screen.dart  # 緊急度+応急処置ステップ
│   │   └── symptom_detail_provider.dart
│   ├── pet_profile/
│   │   ├── pet_profile_screen.dart     # P1: マイペット
│   │   └── pet_profile_provider.dart
│   ├── hospital_search/
│   │   └── hospital_search_screen.dart # P1: 病院検索
│   ├── setting/setting_screen.dart
│   └── paywall/paywall_screen.dart
├── domain/
│   ├── entity/{symptom,category,triage_level,pet,first_aid_step}.dart
│   └── usecase/{get_symptoms_by_category,get_first_aid_steps,evaluate_triage}.dart
├── data/
│   ├── repository/{symptoms,pets,settings}_repository.dart
│   ├── source/hive/{pets,settings,viewed_symptoms}_box.dart
│   └── seed/symptoms_seed.dart           # 30+ 症状の組み込みデータ
└── service/
    ├── ad_service.dart
    └── purchase_service.dart
```

## ルーティング設計（GoRouter）

```dart
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    ShellRoute(
      builder: (_, __, child) => BaseScreen(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/pets', builder: (_, __) => const PetProfileScreen()),
        GoRoute(path: '/setting', builder: (_, __) => const SettingScreen()),
      ],
    ),
    GoRoute(
      path: '/symptoms/:categoryId',
      builder: (_, s) => SymptomListScreen(categoryId: s.pathParameters['categoryId']!),
    ),
    GoRoute(
      path: '/symptom/:symptomId',
      builder: (_, s) => SymptomDetailScreen(symptomId: s.pathParameters['symptomId']!),
    ),
    GoRoute(path: '/hospitals', builder: (_, __) => const HospitalSearchScreen()),
    GoRoute(path: '/paywall', builder: (_, __) => const PaywallScreen()),
  ],
);
```

## 状態管理（Riverpod）

| Provider | 種類 | スコープ |
|----------|------|---------|
| `selectedSpeciesProvider` | StateProvider | 犬/猫の選択状態 |
| `symptomsProvider` | Provider | 全症状（種別+カテゴリ別フィルタ用） |
| `viewedSymptomsCountProvider` | StateProvider | 閲覧済み症状数（フリー3件制限） |
| `petsProvider` | StateNotifierProvider | マイペット CRUD（Hive、P1） |
| `purchaseStatusProvider` | StreamProvider | RevenueCat 購読状態 |

## データソース

### 症状シードデータ（組み込み）

```dart
// lib/data/seed/symptoms_seed.dart
const symptomsSeed = [
  Symptom(
    id: 'dog_vomit',
    species: Species.dog,
    category: 'digestive',
    name: '嘔吐',
    triage: TriageLevel.amber, // 黄: 様子見
    triageRedConditions: ['血が混じる', '6時間以上続く', '飲水できない'],
    firstAidSteps: ['食事を6時間止める', '少量の水を与える', '安静にする'],
    avoidActions: ['人間の薬を与える', '無理に食べさせる'],
    visitVetSigns: ['ぐったりしている', '嘔吐が止まらない', '血が混じる'],
  ),
  // ...30+ symptoms
];
```

### Hive Box

```
pets: HiveBox<Pet>
  - id / name / species / breed / birthYear / weightKg / allergies / chronicIssues

viewed_symptoms: HiveBox<ViewedSymptom>
  - symptomId / viewedAt   # フリー3件制限の判定用

settings: HiveBox<dynamic>
  - language / notificationsEnabled / lastSpecies
```

### 緊急度判定ロジック

```dart
TriageLevel evaluateTriage(Symptom symptom, List<String> selectedConditions) {
  if (selectedConditions.any((c) => symptom.triageRedConditions.contains(c))) {
    return TriageLevel.red; // 即病院
  }
  return symptom.triage; // baseline (amber / green)
}
```

- **赤（即病院）**: 痙攣・大量出血・誤飲・呼吸困難
- **黄（様子見）**: 嘔吐・下痢・食欲低下
- **緑（自宅対処OK）**: 軽度の傷・耳掃除

### 病院検索（P1）

- `geolocator` で現在地取得
- Google Places API or OpenStreetMap で「animal hospital」検索
- 24時間営業フィルタは営業時間情報から判定
- マップは `flutter_map` (OSM)

## プラットフォーム対応

- iOS 14+ / Android 6+ (API 23+)
- iOS のみ Step 13 で TestFlight 配信、Android は P2 以降
- アクセシビリティ: VoiceOver / TalkBack 全画面対応。緊急度バッジは色 + アイコン + テキスト併用
- ダークモード: Step 07 P1（Sage 寄りの深いダーク背景）
- 多言語: 39 言語ローカライズ（ARB）。症状名・応急処置ステップは ARB 化
- Firestore 不使用 → 完全オフライン動作（緊急時に電波がなくても使える）

## 課金トリガー（フリー制限）

- 閲覧症状 3 件目で Paywall 起動
- マイペット 2 匹目で Paywall 起動（P1）
- カテゴリ別フィルタタップで Paywall 起動
