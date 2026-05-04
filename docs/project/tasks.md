# Pet First 実装タスク

## マイルストーン: MVP（5日間）

### Day 1: 基盤
- [ ] flutter-template同期完了
- [ ] Bundle ID `pet.first` 設定
- [ ] Firebase prodプロジェクト作成
- [ ] firebase_options.dart生成
- [ ] App Check設定
- [ ] パッケージ名 `pet_first` への置換確認

### Day 2: データレイヤー
- [ ] Symptom / FirstAidStep / EmergencyLevel モデル定義
- [ ] symptoms.jsonシードファイル作成（30+症状、犬猫別）
- [ ] HiveでSymptomRepository実装
- [ ] アセット画像配置（300KB/枚以下）
- [ ] オフライン動作確認

### Day 3: UI（P0）
- [ ] Splash → Onboarding（3ステップ）
- [ ] Home画面（犬/猫タブ + カテゴリグリッド）
- [ ] SymptomList画面
- [ ] SymptomDetail画面（緊急度バッジ + ステップ + NG警告）
- [ ] 緊急度カラーシステム適用

### Day 4: マネタイズ
- [ ] RevenueCat統合
- [ ] ペイウォール画面（オンボ後・3症状目）
- [ ] AdMob統合（バナー + インター）
- [ ] 赤レベル時に広告非表示の制御
- [ ] 1日3症状制限の実装

### Day 5: 仕上げ
- [ ] 39言語ARB翻訳
- [ ] Firebase Analytics設定
- [ ] Crashlytics統合
- [ ] ローカル通知（M3）
- [ ] D1/D7/D30 計測設定（M6）
- [ ] Privacy Manifest対応
- [ ] プライバシーポリシー / 利用規約 Firebase Hosting配信
- [ ] App Store Connect登録
- [ ] スクリーンショット39言語生成

## 関連Issue

- 後続Stepでテンプレート自動生成

## 依存関係

| 作業 | 依存先 |
|------|-------|
| Symptom DB構築 | 杏（リサーチ）の医療情報監修確認 |
| 39言語翻訳 | 医療用語辞書ベース |
| ASO初期設定 | 指原（マーケ）連携 |
| アイコン・スクショ | 石原（クリエイティブ） |

## リスク・ブロッカー

- 医療情報の監修: 杏に医療系資料リサーチを依頼
- Apple審査: 医療カテゴリは時間かかる傾向→早期submission
- 画像素材: 犬猫の症状画像はAI生成（プロンプト→Gemini→CEO）
