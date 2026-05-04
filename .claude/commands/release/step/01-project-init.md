# 🚀 Step 01: プロジェクト初期化

<!-- LANGUAGE: ja -->
<!-- RESPONSE_LANGUAGE: Japanese -->
<!-- AUTO_EXECUTE: true -->
<!-- NO_USER_INPUT: true -->

<!-- PROGRESS_COMMAND_ID: 01-project-init -->
<!-- PROGRESS_PHASE: phase1 -->
<!-- PROGRESS_NAME: 企画・設計・要件定義 -->
<!-- PROGRESS_TYPE: auto -->
<!-- PROGRESS_ESTIMATED_TIME: 8-12 -->
<!-- PROGRESS_DEPENDENCIES: [] -->
<!-- PROGRESS_STATUS: pending -->
<!-- PROGRESS_EXECUTION_START: -->
<!-- PROGRESS_EXECUTION_END: -->
<!-- PROGRESS_DURATION_MINUTES: -->
<!-- PROGRESS_RESULT: -->
<!-- PROGRESS_LOGS: [] -->

**テンプレートリポジトリ専用** - アイデア生成からリポジトリ構築まで完全自動化

---

## 📥 企画書チェック（Phase 1の前に必ず実行）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
if [ -f "$SPEC_PATH" ]; then
  echo "✅ 企画書あり: $SPEC_PATH"
else
  echo "❌ 企画書なし → 自動探索モードで実行"
fi
```

**企画書ありの場合**: 企画書を読み込み、各Phaseで値を採用。足りない部分のみ自動生成。
**企画書なしの場合**: 従来通りゼロから全て生成。

各Phaseファイルの冒頭に詳細な判定ロジックあり。

---

## 📋 Phase構成（8-12分）

| Phase | 内容 | 概要 |
|-------|------|------|
| 1 | アイデア探索 | 8軸評価で3案選定 |
| 2 | アプリ名決定 | 全39言語ARB + iOS設定 |
| 3 | 競合深掘り | 3案の競合詳細分析・CPI/LTV |
| 4 | ビジネス設計 | 最終1案選定・収益モデル・MVP |
| 5 | 技術設計 | Firebase必須構成・セキュリティ |
| 6 | 要件定義 | ハイブリッド方式（EARS + 画面仕様） |
| 7 | 仕様書作成 | 設計・Mermaid図・実装計画 |
| 8 | リポジトリ構築 | GitHub Private repo作成・移行 |

詳細: `01-phases/` | AI機能: `01-phases/_common/ai-capabilities.md`

---

## 📝 生成される成果物

| Phase | ファイル | 内容 |
|-------|---------|------|
| 1 | `history.json` | プロジェクト履歴・重複チェック |
| 2 | `app_branding.md` | アプリ名・キーワード |
| 3 | `competitor_analysis.md` | 競合分析・差別化戦略 |
| 4 | `business_design.md` | 収益モデル・KPI・MVP |
| 5-6 | `requirements.md` | ハイブリッド要件定義（Part 1-4） |
| 7 | `design.md`, `tasks.md` | アーキテクチャ・実装計画 |
| 8 | GitHub Private repo | 全ドキュメント移行済み（`crelve` 組織配下） |

---

## ⚡ トークン効率化ルール（厳守）

### Phase別読み込み（必須）

```
Phase 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8
```

- **現在のPhaseファイルのみ読み込む**（一括読み込み禁止）
- 各Phase完了後、次のPhaseファイルを読み込む

### 効率化テクニック

| 手法 | 内容 |
|------|------|
| メモリ活用 | Phase 1のWebSearch結果を保存、Phase 2-8で再利用 |
| 並列実行 | 独立したWebSearch等は1メッセージで同時実行 |

---

## 🤖 実行指示

1. Phase 1から順番に実行し、各Phase完了後に進捗報告
2. 詳細は `01-phases/phase{N}-*.md` から読み込む
3. AI機能は `01-phases/_common/ai-capabilities.md` を参照
4. **Phase 8完了後（必須）**: flutter-template の未コミット変更を新リポジトリへ同期する

### Phase 8 補足: 未コミット変更の同期

`make clone-repo REPO_NAME={プロジェクト名}` 実行後、**必ず以下を追加実行**すること。
`make clone-repo` はリモートのコミット済みテンプレートをクローンするため、ローカルの未コミット変更は含まれない。

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

## ✅ 完了時アクション

`RELEASE_CHECKLIST.md` の該当コマンドをチェック済み `[x]` に更新
