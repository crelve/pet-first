# 📱 マーケティングコマンド

リリース後のアプリ成長を加速するマーケティング・分析コマンド集

---

## 🎯 コマンド一覧

### 📈 [user-acquisition.md](user-acquisition.md) - ユーザー獲得戦略
**リリース後のユーザー獲得を最適化**

**実行内容:**
- Firebase Analytics データ分析
- ターゲット市場の再評価
- オーガニック/ペイドチャネル戦略
- 予算別実行プラン（$0〜$2000+/月）
- 成長ハック施策提案

**主な成果物:**
- `docs/project/user_acquisition_strategy.md` - 包括的な獲得戦略
- オーガニックチャネル施策リスト
- ペイド広告の予算配分案
- 90日間実行ロードマップ

**推奨実行タイミング:**
- リリース後 7-30日（データが溜まってから）
- 月次レビュー時
- マーケティング予算の見直し時

---

### 🔍 [aso-optimization.md](aso-optimization.md) - ASO最適化
**App Store / Google Play での検索順位向上**

**実行内容:**
- ASO健康診断（100点満点評価）
- キーワードリサーチ（検索ボリューム×競合度）
- メタデータ最適化提案（タイトル、説明文等）
- スクリーンショット・動画改善案
- 競合アプリ分析

**主な成果物:**
- `docs/project/aso_diagnosis.md` - 現状診断
- `docs/project/aso_keyword_research.md` - キーワード戦略
- `docs/project/aso_optimization_plan.md` - 最適化プラン
- `docs/project/aso_ab_test_roadmap.md` - A/Bテスト計画

**推奨実行タイミング:**
- リリース前（メタデータ最適化）
- リリース後 月1回（継続改善）
- ダウンロード数が伸び悩んだ時

---

### 🎉 [promotion-strategy.md](promotion-strategy.md) - プロモーション戦略
**ローンチ・イベント・キャンペーン計画**

**実行内容:**
- 新規ローンチ戦略（プレ・当日・ポスト）
- メジャーアップデートプロモーション
- 季節・イベント連動キャンペーン
- リファラル・バイラル施策
- リエンゲージメント（休眠ユーザー復帰）

**主な成果物:**
- `docs/project/promotion_strategy.md` - プロモーション計画
- `docs/project/promotion_checklist.md` - 実行チェックリスト
- `docs/project/promotion_creatives.md` - SNS/メールテンプレート

**推奨実行タイミング:**
- アプリローンチ 30日前
- メジャーアップデート前
- 季節イベント 1ヶ月前
- ユーザー獲得キャンペーン開始時

---

## 📊 分析コマンド

マーケティング施策の効果測定・改善に必要な分析コマンドは [../analysis/README.md](../analysis/README.md) をご覧ください:

- **retention-analysis.md** - リテンション分析
- **review-analysis.md** - レビュー分析・対応
- **conversion-funnel.md** - コンバージョンファネル分析

---

## 🚀 推奨実行フロー

### リリース前（L-30日〜L-Day）

```bash
# 1. ASO最適化（L-30日）
/marketing:aso-optimization

# 2. プロモーション計画（L-30日）
/marketing:promotion-strategy
```

### リリース後（L+1日〜）

```bash
# 3. ユーザー獲得戦略（L+7日、データが溜まってから）
/marketing:user-acquisition

# 4. 定期的な改善（月次）
/marketing:aso-optimization       # 月1回
/analysis:retention-analysis      # 月1回
/analysis:review-analysis         # 週1回
/analysis:conversion-funnel       # 月1回
```

---

## 💡 活用のポイント

### 1. データドリブンな意思決定
全てのコマンドは Firebase Analytics / App Store Connect / Google Play Console から実データを取得し、データに基づく提案を行います。

### 2. 継続的な改善
マーケティングは一度実行して終わりではありません。月次で各コマンドを実行し、PDCAサイクルを回しましょう。

### 3. 予算に応じた施策
各コマンドは複数の予算レンジ（$0, $500, $1000, $5000+）に対応した施策を提案します。

### 4. Dart タスク管理連携
各コマンドは、生成した戦略を実行可能なタスクとして Dart に登録できます（オプション）。

---

## 📈 期待される成果

### ASO最適化
- 検索順位: 主要キーワードで Top 10 入り
- ストアページ CVR: +20-40%
- オーガニックインストール: +30-50%

### ユーザー獲得戦略
- 獲得コスト（CPI）: -30-50%
- チャネル別 ROAS: 150-300%
- オーガニック比率: 50-60%

### プロモーション
- ローンチ初週ダウンロード: 500-2,000（無料施策のみ）
- Product Hunt 上位5位: 追加 1,000-3,000 インストール
- イベントキャンペーン: 通常の 2-3倍のダウンロード

---

## 🆘 トラブルシューティング

### データが取得できない
```bash
# Firebase Analytics 確認
firebase login:list
firebase apps:sdkconfig

# App Store Connect API 設定確認
# https://appstoreconnect.apple.com/access/api

# Google Play Console API 確認
# https://play.google.com/console/developers/api-access
```

### 効果が出ない
- 最低 7-30日間のデータ蓄積が必要
- リリース直後は判断材料不足
- 小規模テストから始めて徐々にスケール

---

## 📚 参考リンク

- [Firebase Analytics](https://firebase.google.com/docs/analytics)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api/)
- [Google Play Developer API](https://developers.google.com/android-publisher)
- [Product Hunt ローンチガイド](https://www.producthunt.com/launch)

---

**関連コマンド:**
- [../analysis/README.md](../analysis/README.md) - 分析コマンド
- [../release/README.md](../release/README.md) - リリース自動化コマンド
