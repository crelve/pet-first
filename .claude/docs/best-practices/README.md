# Claude Code Best Practices

このディレクトリには、Claude Code を効率的に使用するためのベストプラクティスをまとめたドキュメントが含まれています。

## 📚 Available Guides

### [Token Efficiency](token-efficiency.md) ⭐ 必読
Claude Code実行時のトークン消費を最適化するための10個の黄金ルール。

**適用範囲:**
- `.claude/commands/release/` 配下の全52コマンド（100%統合済み）
- リリース自動化ワークフロー全体

**効果:**
- 平均70-80%のトークン削減
- 実行速度の大幅向上
- コスト削減

**主要戦略:**
- Serena Memory によるキャッシュ活用
- Just-in-Time 読み込み
- 並列実行
- head_limit による結果制限
- 構造化データ活用

---

## 🎯 使い方

### コマンド実行時
`.claude/commands/release/` 配下のコマンドを実行する際、Claude Code は自動的にこれらのベストプラクティスを参照します。

### 新規コマンド作成時
新しいコマンドファイルを作成する際は、以下のように参照を追加してください：

```markdown
**IMPORTANT:** このコマンド実行前に、必ず以下を参照してください：
- **[トークン効率化ベストプラクティス](相対パス/token-efficiency.md)** - 10個の黄金ルール
```

**相対パスの例:**
- `.claude/commands/release/*.md` → `../../docs/best-practices/token-efficiency.md`
- `.claude/commands/release/step/*.md` → `../../../docs/best-practices/token-efficiency.md`
- `.claude/commands/release/step/XX-modules/*.md` → `../../../../docs/best-practices/token-efficiency.md`

---

## 📋 Future Best Practices

今後、以下のようなベストプラクティスが追加される予定です：

- **error-handling.md** - エラーハンドリング戦略
- **testing-strategies.md** - テスト自動化のベストプラクティス
- **code-review.md** - コードレビューの効率化
- **git-workflows.md** - Git/GitHub ワークフローのベストプラクティス

---

## 🤝 Contributing

新しいベストプラクティスを追加する際は：

1. わかりやすいファイル名を使用（kebab-case）
2. 実践的な例を含める
3. 削減効果や改善指標を明示
4. このREADMEのリストに追加
5. 該当するコマンドファイルから参照を追加
