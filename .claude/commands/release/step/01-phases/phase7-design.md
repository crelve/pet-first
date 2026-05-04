# 📝 Phase 7: 仕様書作成

## 目的
設計ドキュメント生成 → 実装計画・タスク分解

---

## 📥 企画書チェック（最初に実行）

```bash
APP_NAME=$(basename $(pwd))
SPEC_PATH=~/kikiki/released/company/planning/specs/${APP_NAME}-spec.md
ls "$SPEC_PATH" 2>/dev/null
```

**企画書が存在する場合:**
- Phase 5-6の出力を基に設計書を生成（企画書は直接参照しない）
- 企画書の内容は既にPhase 1-6で `docs/project/` に反映済み

**企画書がない場合:**
- 通常フロー

---

## 実行内容

### 1. 設計・Mermaid図生成
- アーキテクチャ図
- データフロー図
- 画面遷移図

### 2. 実装計画
- タスク分解（22ステップ連携）
- 依存関係マッピング

### 3. AI機能設計（採用時）
[_common/ai-capabilities.md](_common/ai-capabilities.md) 参照

設計項目:
- Firebase AIアーキテクチャ図
- プロンプト設計
- エラーハンドリング・フォールバック
- UX設計（ローディング、ストリーミングUI）
- コスト管理

### 4. テンプレート配置
`.claude/docs/templates/feature_spec_template.md` → `docs/project/feature_specifications.md`

---

## 成果物

| ファイル | 内容 |
|---------|------|
| `docs/project/design.md` | 設計・Mermaid図 |
| `docs/project/tasks.md` | 実装計画 |
| `docs/project/app_concept.md` | ビジネスコンセプト |
| `docs/project/feature_specifications.md` | 機能仕様テンプレート |
| `docs/project/ai_design.md` | AI機能設計書（採用時） |

---

## 🤖 実行指示
- Phase 1-6メモリから全情報集約
- Mermaid図は簡潔に
- テンプレートは `cp` で効率的にコピー
