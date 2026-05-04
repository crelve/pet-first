# 🔗 Phase 8: リポジトリ構築

## 目的
新リポジトリ作成 → GitHub統合・開発環境準備

---

## プロジェクト名の命名規則

⚠️ **必須**: [naming_conventions.md](../../../docs/rules/naming_conventions.md) 準拠

| ルール | 例 |
|--------|-----|
| ✅ ケバブケース | `habit-flow`, `quick-shop` |
| ❌ アンダースコア | `habit_flow` |
| ❌ 大文字 | `HabitFlow` |
| 📏 長さ | 6-30文字 |

---

## 実行コマンド

```bash
make clone-repo REPO_NAME={プロジェクト名}
```

---

## 自動実行される処理

1. 🔒 Privateリポジトリ作成（`https://github.com/crelve/{プロジェクト名}` 配下）
2. 📋 テンプレート複製
3. 📄 `docs/project/` 全ファイル移行
4. 🔐 シークレット対策（fastlane/.env クリーンアップ）
5. 📝 初期コミット・プッシュ
6. ⚙️ `make setup` 実行
7. 🛡️ グローバル履歴登録
8. 📂 **flutter-templateの未コミット変更を含む完全同期**（以下の手順）

---

## 🔄 未コミット変更の同期（必須）

`make clone-repo` はリモートのコミット済みテンプレートをクローンするため、
flutter-template のローカル未コミット変更は含まれない。
**`make clone-repo` 実行後、必ず以下を追加実行すること。**

```bash
# flutter-template 作業ツリーを新リポジトリへ同期（未コミット変更を含む）
rsync -av \
  --exclude='.git/' \
  --exclude='build/' \
  --exclude='.dart_tool/' \
  --exclude='.flutter-plugins' \
  --exclude='.flutter-plugins-dependencies' \
  . ../{REPO_NAME}/

# 変更をコミット・プッシュ
cd ../{REPO_NAME}
git add .
git commit -m "sync: flutter-templateの未コミット変更を反映" || echo "変更なし"
git push
```

**除外ルール**:
- `build/`, `.dart_tool/`: ローカルビルドキャッシュは不要
- `docs/project/` は **除外しない**（Phase 1-7 の成果物が格納されているため、同期対象に含める）

---

## README.md 更新（必須）

rsync 完了後、テンプレートデフォルトの `README.md` をアプリ固有の内容に書き換える。

**更新内容:**
- タイトル・説明をアプリ名・コンセプトに変更
- ターゲット・マネタイズ（価格表）
- 主要機能（MVP / 拡張予定）
- 技術スタック（実際に使用するものに絞る）
- プロジェクト構造（スクリーン名を具体化）
- KPIターゲット
- `docs/project/` への参照リンク

**情報源（全て `docs/project/` から取得）:**
- `app_concept.md` → コンセプト・エレベーターピッチ
- `app_branding.md` → アプリ名・ターゲット
- `business_design.md` → マネタイズ・KPI・MVP機能
- `competitor_analysis.md` → 競合・差別化
- `tech_design.md` → 技術スタック
- `requirements.md` → 画面構成・機能一覧

---

## 成果物
- GitHub Private リポジトリ（flutter-template の全変更を含む）
- 全プロジェクトドキュメント
- `README.md`（アプリ固有の内容に更新済み）
- `~/.flutter-template/project_history.json` 更新

---

## 🤖 実行指示
- プロジェクト名はPhase 1-4メモリから取得
- `make clone-repo` をBashで実行
- **`make clone-repo` 完了後、上記の rsync コマンドを必ず実行する**
- **rsync 完了後、`README.md` を上記の内容で更新する**
- グローバル履歴は既存保持して追加（上書き禁止）
