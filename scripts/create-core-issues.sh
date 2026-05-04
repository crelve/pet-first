#!/bin/bash

# WeatherWear Core機能Issue一括作成スクリプト
# 要件定義書(docs/project/requirements.md)に基づいてGitHub Issuesを自動作成

set -e

# 設定
REPO_OWNER=${GITHUB_REPOSITORY_OWNER:-"$(gh repo view --json owner --jq .owner.login)"}
REPO_NAME=${GITHUB_REPOSITORY_NAME:-"$(gh repo view --json name --jq .name)"}
MILESTONE="Week 1-2: Core Features"

echo "🚀 WeatherWear Core機能Issues作成開始"
echo "Repository: $REPO_OWNER/$REPO_NAME"

# マイルストーン作成
echo "📅 マイルストーン作成: $MILESTONE"
gh api repos/$REPO_OWNER/$REPO_NAME/milestones \
  --method POST \
  --field title="$MILESTONE" \
  --field description="Core機能（F001-F004）の実装" \
  --field due_on="$(date -d '+14 days' -Iseconds)" || echo "マイルストーン既存または作成エラー"

# F001: 天気情報表示機能
echo "🌤️  F001: 天気情報表示機能Issues作成"

cat << 'EOF' | gh issue create --title "[機能] F001-1: OpenWeatherMap API統合基盤構築" --body-file - --label "feature,implementation,phase-2-core,priority-high,F001"
## 📋 要件定義参照

**要件ID**: F001-1  
**要件名**: 天気情報表示 - API基盤構築  
**優先度**: 高  
**関連ドキュメント**: 
- [x] `docs/project/requirements.md` のF001セクション確認済み
- [x] `docs/project/app_concept.md` の関連機能確認済み

## 🎯 実装目標

### 機能概要
OpenWeatherMap APIとの統合基盤を構築し、天気データの取得・パース・エラーハンドリングの基本機能を実装します。

### 受け入れ基準
- [ ] OpenWeatherMap APIキー設定・認証成功
- [ ] 基本的な天気データ取得APIコール成功  
- [ ] レスポンスデータのパース・バリデーション実装
- [ ] API エラー時の適切なエラーハンドリング
- [ ] Unit テストカバレッジ80%以上

## 🔨 実装詳細

### 技術スコープ
- [x] **Frontend**: Flutter/Dart実装
- [ ] **Backend**: Firebase Functions/Firestore
- [x] **API**: OpenWeatherMap API統合
- [ ] **UI/UX**: デザインシステム準拠
- [x] **Testing**: Unit/Integration テスト

### 実装ファイル
- [x] `lib/model/weather_model.dart` - 天気データモデル
- [x] `lib/provider/weather_provider.dart` - 天気データ状態管理
- [x] `lib/utility/weather_api_client.dart` - API クライアント
- [x] `test/utility/weather_api_client_test.dart` - Unit テスト
- [x] `dart_env/dev.env` - API キー設定

### 依存関係
- [ ] 前提となる機能・Issue: なし
- [x] 連携する外部サービス: OpenWeatherMap API
- [x] 必要なパッケージ・ライブラリ: http, freezed, json_annotation

## ✅ 実装チェックリスト

### Phase 1: 設計・準備
- [ ] 要件定義の詳細確認
- [ ] OpenWeatherMap API仕様調査
- [ ] データモデル設計
- [ ] エラーハンドリング方針決定

### Phase 2: 実装
- [ ] WeatherModel データクラス実装
- [ ] WeatherApiClient HTTP クライアント実装
- [ ] WeatherProvider 状態管理実装
- [ ] API キー設定・環境変数管理

### Phase 3: テスト・品質保証
- [ ] Unit テスト実装（API クライアント）
- [ ] Unit テスト実装（データモデル）
- [ ] Integration テスト実装
- [ ] `make test` 成功
- [ ] `fvm flutter analyze` エラーなし

### Phase 4: 受け入れテスト
- [ ] API呼び出し・レスポンス確認
- [ ] エラーケースの動作確認
- [ ] パフォーマンス確認（3秒以内応答）
- [ ] メモリリーク確認

## 📊 パフォーマンス要件

- [ ] API レスポンス時間: 3秒以内
- [ ] メモリ使用量: +10MB以下
- [ ] API呼び出し頻度: 30分キャッシュ

## 🧪 テスト戦略

### テスト観点
- [x] API呼び出し正常系
- [x] API エラー応答処理
- [x] データパース・バリデーション
- [x] キャッシュ機能（将来実装）

## ✅ 完了条件

- [ ] API統合基盤実装完了
- [ ] Unit/Integration テスト合格
- [ ] PR作成・レビュー・マージ完了
- [ ] 要件F001-1の受け入れ基準すべて満たす
EOF

cat << 'EOF' | gh issue create --title "[機能] F001-2: 位置情報サービス実装" --body-file - --label "feature,implementation,phase-2-core,priority-high,F001"
## 📋 要件定義参照

**要件ID**: F001-2  
**要件名**: 天気情報表示 - 位置情報取得  
**優先度**: 高  
**関連ドキュメント**: 
- [x] `docs/project/requirements.md` のF001セクション確認済み

## 🎯 実装目標

### 機能概要
ユーザーの現在地または指定地点の位置情報を取得し、天気API呼び出しに使用する位置情報サービスを実装します。

### 受け入れ基準
- [ ] 位置情報権限の適切な取得・管理
- [ ] 現在地の自動取得機能
- [ ] 手動地点指定機能
- [ ] 位置情報取得エラーの適切な処理
- [ ] iOS対応

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/provider/location_provider.dart` - 位置情報状態管理
- [x] `lib/utility/location_service.dart` - 位置情報サービス
- [x] `lib/model/location_model.dart` - 位置データモデル
- [x] `test/utility/location_service_test.dart` - Unit テスト

### 依存関係
- [ ] 前提となる機能・Issue: なし
- [x] 必要なパッケージ: geolocator

## ✅ 実装チェックリスト

### Phase 2: 実装
- [ ] LocationModel データクラス実装
- [ ] LocationService 位置情報取得実装
- [ ] LocationProvider 状態管理実装
- [ ] 権限管理・エラーハンドリング実装

### Phase 3: テスト・品質保証
- [ ] Unit テスト実装
- [ ] iOS実機テスト
- [ ] 権限拒否ケーステスト

## ✅ 完了条件

- [ ] 位置情報サービス実装完了
- [ ] 実機での動作確認
- [ ] 要件F001-2の受け入れ基準すべて満たす
EOF

cat << 'EOF' | gh issue create --title "[機能] F001-3: 天気データキャッシュ機構実装" --body-file - --label "feature,implementation,phase-2-core,priority-medium,F001"
## 📋 要件定義参照

**要件ID**: F001-3  
**要件名**: 天気情報表示 - キャッシュ機構  
**優先度**: 中  

## 🎯 実装目標

### 機能概要
APIコスト最適化とオフライン対応のため、天気データの30分キャッシュ機構を実装します。

### 受け入れ基準
- [ ] 30分間のキャッシュ有効期限管理
- [ ] オフライン時のキャッシュデータ表示
- [ ] キャッシュ無効化・更新機能
- [ ] ストレージ容量管理

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/utility/cache_service.dart` - キャッシュサービス
- [x] `lib/provider/weather_provider.dart` - キャッシュ連携
- [x] `test/utility/cache_service_test.dart` - Unit テスト

### 依存関係
- [x] 前提となる機能・Issue: #[F001-1のIssue番号]
- [x] 必要なパッケージ: shared_preferences, hive

## ✅ 完了条件

- [ ] キャッシュ機構実装完了
- [ ] オフライン対応確認
- [ ] 要件F001-3の受け入れ基準すべて満たす
EOF

cat << 'EOF' | gh issue create --title "[機能] F001-4: 天気データ表示UI実装" --body-file - --label "feature,implementation,phase-2-core,priority-high,F001"
## 📋 要件定義参照

**要件ID**: F001-4  
**要件名**: 天気情報表示 - UI実装  
**優先度**: 高  

## 🎯 実装目標

### 機能概要
取得した天気データを美しく分かりやすく表示するUIコンポーネントを実装します。

### 受け入れ基準
- [ ] 現在気温・体感気温表示
- [ ] 天気アイコンが状況に対応して正確に表示
- [ ] 降水確率・降水量の視覚的表示
- [ ] 湿度・風速・UV指数表示
- [ ] 時間別予報（6時間先まで）表示

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/component/weather/weather_card.dart` - 天気カードコンポーネント
- [x] `lib/component/weather/weather_icon.dart` - 天気アイコン
- [x] `lib/component/weather/hourly_forecast.dart` - 時間別予報
- [x] `lib/screen/home/home_screen.dart` - メイン画面統合
- [x] `test/component/weather/weather_card_test.dart` - Widget テスト

### 依存関係
- [x] 前提となる機能・Issue: #[F001-1, F001-2, F001-3のIssue番号]

## ✅ 完了条件

- [ ] 天気表示UI実装完了
- [ ] Widget テスト合格
- [ ] デザインシステム準拠確認
- [ ] 要件F001-4の受け入れ基準すべて満たす
EOF

# F002: 服装提案機能
echo "👔 F002: 服装提案機能Issues作成"

cat << 'EOF' | gh issue create --title "[機能] F002-1: 服装提案アルゴリズム基盤実装" --body-file - --label "feature,implementation,phase-2-core,priority-high,F002"
## 📋 要件定義参照

**要件ID**: F002-1  
**要件名**: 服装提案機能 - アルゴリズム基盤  
**優先度**: 高  

## 🎯 実装目標

### 機能概要
天気情報とユーザープロフィールに基づく服装提案アルゴリズムの基盤を実装します。

### 受け入れ基準
- [ ] 気温・体感気温に基づく基本提案ロジック
- [ ] 降水・風・UV指数による調整ロジック
- [ ] ユーザーの年齢・性別・体質考慮
- [ ] 代替案の提示（最大3案）
- [ ] 提案生成1秒以内

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/model/outfit_model.dart` - 服装データモデル
- [x] `lib/utility/outfit_algorithm.dart` - 提案アルゴリズム
- [x] `lib/provider/outfit_provider.dart` - 服装提案状態管理
- [x] `test/utility/outfit_algorithm_test.dart` - Unit テスト

### 依存関係
- [x] 前提となる機能・Issue: #[F001関連Issues]

## ✅ 完了条件

- [ ] 服装提案アルゴリズム実装完了
- [ ] Unit テスト合格（95%精度目標）
- [ ] 要件F002-1の受け入れ基準すべて満たす
EOF

cat << 'EOF' | gh issue create --title "[機能] F002-2: 服装提案UI実装" --body-file - --label "feature,implementation,phase-2-core,priority-high,F002"
## 📋 要件定義参照

**要件ID**: F002-2  
**要件名**: 服装提案機能 - UI実装  
**優先度**: 高  

## 🎯 実装目標

### 機能概要
服装提案を視覚的に分かりやすく表示し、代替案の選択機能を持つUIを実装します。

### 受け入れ基準
- [ ] メイン提案の表示（アイテム別）
- [ ] 代替案のスワイプ選択機能
- [ ] 提案理由の説明表示
- [ ] ユーザーフィードバック収集UI

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/component/outfit/outfit_suggestion_card.dart` - 提案カード
- [x] `lib/component/outfit/outfit_item.dart` - アイテム表示
- [x] `lib/component/outfit/alternative_options.dart` - 代替案表示
- [x] `lib/screen/home/home_screen.dart` - メイン画面統合

### 依存関係
- [x] 前提となる機能・Issue: #[F002-1のIssue番号]

## ✅ 完了条件

- [ ] 服装提案UI実装完了
- [ ] スワイプ操作動作確認
- [ ] 要件F002-2の受け入れ基準すべて満たす
EOF

# F003: 通知機能
echo "🔔 F003: 通知機能Issues作成"

cat << 'EOF' | gh issue create --title "[機能] F003-1: プッシュ通知基盤実装" --body-file - --label "feature,implementation,phase-2-core,priority-high,F003"
## 📋 要件定義参照

**要件ID**: F003-1  
**要件名**: 通知機能 - プッシュ通知基盤  
**優先度**: 高  

## 🎯 実装目標

### 機能概要
Firebase Cloud Messagingを使用したプッシュ通知の基盤を実装します。

### 受け入れ基準
- [ ] FCM統合・デバイストークン管理
- [ ] iOS通知権限適切取得
- [ ] 通知受信・処理実装
- [ ] 通知タップ時のアプリ内遷移

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/utility/notification_service.dart` - 通知サービス
- [x] `lib/provider/notification_provider.dart` - 通知状態管理
- [x] `test/utility/notification_service_test.dart` - Unit テスト

### 依存関係
- [x] 必要なパッケージ: firebase_messaging

## ✅ 完了条件

- [ ] プッシュ通知基盤実装完了
- [ ] iOS実機での通知確認
- [ ] 要件F003-1の受け入れ基準すべて満たす
EOF

cat << 'EOF' | gh issue create --title "[機能] F003-2: 朝の服装提案通知実装" --body-file - --label "feature,implementation,phase-2-core,priority-high,F003"
## 📋 要件定義参照

**要件ID**: F003-2  
**要件名**: 通知機能 - 朝の提案通知  
**優先度**: 高  

## 🎯 実装目標

### 機能概要
設定時間での服装提案通知とスケジューリング機能を実装します。

### 受け入れ基準
- [ ] ユーザー指定時間での通知（デフォルト7:00）
- [ ] 指定時間±1分以内で通知送信
- [ ] 週末/祝日の設定
- [ ] 通知のオン/オフ設定

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/utility/notification_scheduler.dart` - 通知スケジューラ
- [x] `lib/screen/setting/notification_setting_screen.dart` - 設定画面
- [x] `lib/provider/setting_provider.dart` - 設定状態管理

### 依存関係
- [x] 前提となる機能・Issue: #[F003-1のIssue番号]
- [x] 必要なパッケージ: flutter_local_notifications

## ✅ 完了条件

- [ ] 朝の通知機能実装完了
- [ ] 設定画面実装完了
- [ ] 要件F003-2の受け入れ基準すべて満たす
EOF

# F004: ユーザー設定
echo "⚙️ F004: ユーザー設定機能Issues作成"

cat << 'EOF' | gh issue create --title "[機能] F004-1: ユーザープロフィール設定実装" --body-file - --label "feature,implementation,phase-2-core,priority-medium,F004"
## 📋 要件定義参照

**要件ID**: F004-1  
**要件名**: ユーザー設定機能 - プロフィール設定  
**優先度**: 中  

## 🎯 実装目標

### 機能概要
個人に最適化された提案のためのユーザープロフィール設定機能を実装します。

### 受け入れ基準
- [ ] 初回起動時の設定フロー完了
- [ ] 年齢層・性別・体質・スタイル設定
- [ ] 通知時間・地点設定
- [ ] 設定変更の即座反映
- [ ] データの永続保存

## 🔨 実装詳細

### 実装ファイル
- [x] `lib/model/user_profile_model.dart` - プロフィールモデル
- [x] `lib/screen/setting/profile_setting_screen.dart` - 設定画面
- [x] `lib/screen/walk_through/onboarding_screen.dart` - 初回設定
- [x] `lib/provider/user_profile_provider.dart` - プロフィール状態管理

## ✅ 完了条件

- [ ] ユーザー設定機能実装完了
- [ ] オンボーディングフロー実装完了
- [ ] 要件F004-1の受け入れ基準すべて満たす
EOF

echo "✅ Core機能Issues作成完了"
echo "📊 作成されたIssues確認: gh issue list --label 'phase-2-core'"
echo ""
echo "次のステップ:"
echo "1. 各Issueの詳細確認・調整"
echo "2. 実装開始（優先度highから）"
echo "3. 進捗管理: gh project view"