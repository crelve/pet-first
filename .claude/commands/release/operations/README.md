# 📈 Operations Phase - リリース後運用コマンド

リリース後のアプリ運用・改善サイクルを支援するコマンド群です。

---

## コマンド一覧

### KPIレビュー

| コマンド | 説明 | 頻度 |
|---------|------|------|
| `/release:operations:kpi-daily` | 日次KPIレビュー | 毎日 |
| `/release:operations:kpi-weekly` | 週次KPIレビュー | 週1回 |
| `/release:operations:kpi-monthly` | 月次KPIレビュー | 月1回 |
| `/release:operations:dau-trend {appId}` | DAUトレンド確認 | 随時 |
| `/release:operations:app-detail {appId}` | アプリ詳細メトリクス | 随時 |

### 運用最適化

| コマンド | 説明 | 頻度 |
|---------|------|------|
| `/release:operations:02-aso-optimization` | ASO最適化 | 週1〜月1回 |
| `/release:operations:03-ab-testing` | A/Bテスト管理 | 随時 |
| `/release:operations:04-user-feedback` | フィードバック分析 | 毎日〜月1回 |
| `/release:operations:05-competitor-watch` | 競合監視 | 週1〜四半期 |

---

## 運用フロー

| Phase | 内容 | 頻度 | 所要時間 |
|-------|------|------|----------|
| 日次 | KPIチェック、レビュー確認・返信 | 毎日 | 5-10分 |
| 週次 | KPI、キーワード順位、競合更新、フィードバック | 週1回 | 30-60分 |
| 月次 | KPI、ASO最適化、競合レポート、A/Bテスト | 月1回 | 2-4時間 |
| 四半期 | KPI、戦略見直し、競合分析、目標設定 | 四半期 | 4-8時間 |

**改善サイクル**: 計測(KPI) → 分析 → 仮説(テスト設計) → 実行(A/B) → 検証 → 計測...

---

## データソース

| ソース | 取得情報 | 状態 |
|--------|---------|------|
| Firebase Analytics | DAU/MAU、セッション | 自動連携 |
| Firebase Crashlytics | クラッシュ率、エラー | 自動連携 |
| Firebase Remote Config | A/Bテスト設定 | 要設定 |
| AdMob | 広告収益、eCPM | ダッシュボード |
| RevenueCat | サブスク収益、転換率 | API連携（オプション） |
| App Store Connect | DL数、レビュー、ASO | API連携（オプション） |

---

## 成果物の保存先

```
docs/project/
├── kpi_reviews/     # KPIレビュー（daily/weekly/monthly/quarterly）
├── aso/             # ASO関連（keywords.md、月次レポート）
├── ab_tests/        # A/Bテスト（backlog、active、completed）
├── feedback/        # フィードバック（backlog、週次・月次レポート）
└── competitors/     # 競合分析（profiles、週次・月次・四半期）
```

---

**🎯 目標**: 継続的な改善サイクルでMRR目標を達成し、アプリを成長させる
