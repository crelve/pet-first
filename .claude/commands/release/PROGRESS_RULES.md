# 📊 リリースコマンド進捗管理ルール


## 🎯 自動進捗更新システム

各リリースコマンド実行時、Claude Codeが自動で進捗を追跡・更新します。

## 📋 進捗メタデータ

各コマンドファイルの先頭に進捗情報を記述：

```markdown
<!-- PROGRESS_COMMAND_ID: 01-project-init -->
<!-- PROGRESS_PHASE: phase1 -->  
<!-- PROGRESS_NAME: 企画・設計・要件定義 -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_RESULT: -->
```

### 自動更新動作

1. **実行開始**: `PROGRESS_STATUS: in_progress` 
2. **実行完了**: `PROGRESS_STATUS: completed`, `PROGRESS_RESULT: success/failed`
3. **進捗表示**: `RELEASE_CHECKLIST.md` の該当項目を ✅ に更新

## 使用方法

1. コマンド実行時、Claude Codeが自動で進捗を認識・更新
2. `RELEASE_CHECKLIST.md` で全体進捗を確認
3. 完了したコマンドは自動で ✅ マーク