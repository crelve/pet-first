# 📊 分析コマンド

リリース後のアプリ改善に必要なデータ分析・KPI測定コマンド集

---

## 🎯 コマンド一覧

### 🔄 [retention-analysis.md](retention-analysis.md) - リテンション分析
**ユーザー継続率を深堀り分析し、改善施策を提案**

**実行内容:**
- コホート分析（日別・週別・月別）
- セグメント別リテンション比較
- チャーン（離脱）要因分析
- リテンション改善施策の優先順位付け
- リテンションダッシュボード設計

**主な成果物:**
- `docs/project/retention_analysis_report.md` - 分析レポート
- `docs/project/retention_dashboard_spec.md` - ダッシュボード設計
- Quick Wins 施策リスト
- 90日間改善ロードマップ

**重要指標:**
- D1（1日後）リテンション: 40-50% が優秀
- D7（7日後）リテンション: 20-30% が優秀
- D30（30日後）リテンション: 10-20% が優秀

**推奨実行タイミング:**
- リリース後 7日（初期データ取得）
- リリース後 30日（本格分析）
- 月次定例レビュー

---

### ⭐ [review-analysis.md](review-analysis.md) - レビュー分析・対応
**App Store / Google Play のレビューを分析し、評価向上**

**実行内容:**
- 感情分析（ポジティブ/ネガティブ）
- 頻出する問題点・要望の抽出
- 評価別（★1-5）のトレンド分析
- 競合アプリとの比較
- レビュー返信テンプレート生成

**主な成果物:**
- `docs/project/review_sentiment_analysis.md` - 感情分析
- `docs/project/competitor_review_analysis.md` - 競合比較
- `docs/project/review_improvement_plan.md` - 改善計画
- `docs/project/review_responses_draft.md` - 返信案

**重要指標:**
- 平均評価: ★4.5 以上が目標
- レビュー数: 多いほど信頼性向上
- 直近30日の新鮮なレビュー: ASO に重要

**推奨実行タイミング:**
- 週1回（レビュー対応）
- 月1回（トレンド分析）
- 評価が下がった時（緊急対応）

---

### 🎯 [conversion-funnel.md](conversion-funnel.md) - コンバージョンファネル分析
**ユーザージャーニー全体を可視化し、離脱ポイントを特定**

**実行内容:**
- ファネル全体の可視化（各ステップのCVR）
- 最大の離脱ポイントの特定
- セグメント別ファネル比較
- 改善施策の優先順位付け
- A/Bテスト計画の策定

**主な成果物:**
- `docs/project/funnel_visualization.md` - ファネル可視化（Mermaid図）
- `docs/project/funnel_drop_off_analysis.md` - 離脱要因分析
- `docs/project/funnel_improvement_plan.md` - 改善計画
- `docs/project/funnel_ab_test_roadmap.md` - A/Bテスト計画

**典型的なファネル:**
1. ストアページ訪問 → 2. インストール（CVR 20-40%）
2. インストール → 3. 初回起動（CVR 60-80%）
3. 初回起動 → 4. オンボーディング完了（CVR 30-60%）
4. オンボーディング完了 → 5. 主要機能利用（CVR 20-40%）
5. 主要機能利用 → 6. 課金（CVR 1-5%）

**推奨実行タイミング:**
- リリース後 30日（本格分析）
- 月次定例レビュー
- CVR が悪化した時

---

## 🚀 推奨実行フロー

### 初回分析（リリース後 30日）

```bash
# 1. リテンション分析（最優先）
/analysis:retention-analysis

# 2. レビュー分析
/analysis:review-analysis

# 3. ファネル分析
/analysis:conversion-funnel
```

### 定期分析（月次）

```bash
# 月初: 前月のレビュー分析
/analysis:review-analysis

# 月中: リテンション分析
/analysis:retention-analysis

# 月末: ファネル分析 & 改善施策の効果測定
/analysis:conversion-funnel
```

### 週次分析

```bash
# 毎週月曜日: レビュー確認・返信
/analysis:review-analysis
```

---

## 💡 活用のポイント

### 1. データ量の確保
- 最低: 100 インストール、7日間のデータ
- 推奨: 1,000 インストール、30日間のデータ
- 理想: 10,000 インストール、90日間のデータ

### 2. 統計的有意性の考慮
- A/Bテストは最低 1,000ユーザー/グループ
- 95% 信頼区間で判断
- サンプルサイズが小さい場合は慎重に

### 3. セグメント分析の重要性
- 全体平均だけでなくセグメント別に分析
- iOS vs Android、地域別、流入元別等
- 高パフォーマンスセグメントに注力

### 4. 継続的な改善
- 月次で分析 → 改善施策 → 効果測定 のサイクル
- Quick Wins を優先的に実行
- Major Projects は計画的に

---

## 📈 期待される成果

### リテンション分析
- D7 リテンション: +10-20%
- チャーン率: -15-30%
- LTV: +20-50%

### レビュー分析・対応
- 平均評価: +0.2-0.5 ★
- ★1-2 レビュー: -30-50%
- ストアページ CVR: +10-20%

### ファネル分析
- 各ステップの CVR: +5-20%
- 課金 CVR: +10-30%
- ROAS: +50-100%

---

## 🔗 関連コマンド

### マーケティングコマンドと組み合わせる

```bash
# 分析結果を元にマーケティング戦略を立案
/analysis:retention-analysis         # リテンション分析
↓
/marketing:user-acquisition          # 高リテンションセグメントに予算集中

/analysis:review-analysis            # レビュー分析
↓
/marketing:aso-optimization          # ネガティブ要因をASO に反映

/analysis:conversion-funnel          # ファネル分析
↓
/marketing:promotion-strategy        # ボトルネック解消キャンペーン
```

---

## 🆘 トラブルシューティング

### Firebase Analytics データが取得できない

```bash
# Firebase 設定確認
firebase login:list
firebase apps:sdkconfig

# Analytics 有効化確認
# Firebase Console > Analytics > Events

# SDK 統合確認
# アプリに Firebase SDK が正しく統合されているか
```

### データ量が不足している

```bash
「推奨データ量:
   - 最低: 100 インストール、7日間
   - 推奨: 1,000 インストール、30日間
   - 理想: 10,000 インストール、90日間

データ不足時の対応:
   - ベータテスト期間のデータ活用
   - 競合ベンチマークで補完
   - サンプルサイズを考慮した統計処理」
```

### API アクセスエラー

```bash
# App Store Connect API
# https://appstoreconnect.apple.com/access/api

# Google Play Console API
# https://play.google.com/console/developers/api-access

# 権限・認証情報を確認
```

---

## 📚 参考リンク

- [Firebase Analytics](https://firebase.google.com/docs/analytics)
- [Amplitude ガイド](https://amplitude.com/blog)
- [Mixpanel ガイド](https://mixpanel.com/blog)
- [App Annie インサイト](https://www.appannie.com/jp/insights/)

---

**関連コマンド:**
- [../marketing/README.md](../marketing/README.md) - マーケティングコマンド
- [../release/README.md](../release/README.md) - リリース自動化コマンド
