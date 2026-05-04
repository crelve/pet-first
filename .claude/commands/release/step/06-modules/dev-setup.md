# Step 2: 開発環境セットアップ

## 目的
開発環境の完全セットアップ・ビルド検証

---

## 実行フロー

### 1. 依存関係インストール
```bash
# Flutter依存関係取得
flutter pub get

# CocoaPods依存関係インストール（iOS）
cd ios && pod install && cd ..

# Expected: ✅ All dependencies installed
```

### 2. コード生成実行
```bash
# Freezed/Riverpodコード生成
flutter pub run build_runner build --delete-conflicting-outputs

# Expected: ✅ Code generation completed
```

### 3. 静的解析チェック
```bash
# 静的解析実行
flutter analyze

# Expected: No issues found
```

---

## エラー対応

### 依存関係エラー
```bash
# キャッシュクリア後に再取得
flutter clean
flutter pub get
```

### コード生成エラー
```bash
# 既存生成ファイル削除後に再生成
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🤖 Claude Code への指示

**トークン効率化:**
- エラーなしの場合、詳細出力不要
- ビルドログは最終結果のみ表示
- 並列実行可能なコマンドは1メッセージで実行
