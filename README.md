# Pet First – Emergency Pet First Aid

**「うちの子が変。今すぐ確認、ペットの応急処置」**

犬・猫の異常症状（嘔吐・下痢・痙攣・誤飲等）を選ぶだけで緊急度判定（赤:即病院/黄:様子見/緑:自宅対処OK）と正しい応急処置を即表示。深夜の「これ大丈夫？」を3秒で解決するペットオーナーの安心アプリ。

## 主要機能

- **症状別ガイド**: 犬/猫別に30+症状→緊急度判定（赤:即病院/黄:様子見/緑:自宅対処）
- **応急処置ステップ**: 各症状の正しい対処手順 + やってはいけないNG行為
- **オフライン完全対応**: 全コンテンツローカル保存。深夜・電波なしでも100%動作
- **ペットプロフィール（P1）**: 体重・アレルギー・既往歴を保存して獣医に共有
- **動物病院検索（P1）**: 位置情報から最寄りの夜間対応動物病院を表示

## 技術スタック

| 項目 | 技術 |
|------|------|
| フレームワーク | Flutter + flutter_foundation |
| 状態管理 | Riverpod + Flutter Hooks |
| ローカルDB | Hive |
| 多言語 | Flutter Intl（39言語） |
| 収益化 | RevenueCat + AdMob |
| Backend | Firebase（Hosting/FCM/Analytics/Crashlytics） |

## 開発セットアップ

```bash
git clone https://github.com/crelve/pet-first
cd pet-first
make setup
```

## ビルド

```bash
make build-dev    # 開発ビルド
make build-prod   # 本番ビルド
```

## カテゴリ別症状

- 嘔吐・下痢
- 誤飲・中毒
- 痙攣・意識障害
- 外傷・出血
- 呼吸器症状
- 皮膚・耳のトラブル

## シリーズ

- [first-aid](https://github.com/crelve/first-aid) — 人間用応急処置ガイド
- pet-first — 犬・猫の応急処置ガイド（本リポジトリ）
