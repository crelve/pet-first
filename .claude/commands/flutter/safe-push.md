# safe-push

## 概要
コード品質チェック付きの安全なプッシュコマンドです。フォーマット、静的解析、テストを実行してからgit pushを行い、Lefthookエラーを事前に防ぎます。

## 実行内容
1. **品質チェック**: `make check-ready` と同等の処理
   - フォーマット: `fvm dart format lib/ test/`
   - 静的解析: `fvm flutter analyze`
   - テスト実行: `fvm flutter test --dart-define-from-file=dart_env/test.env`
2. **Git プッシュ**: `git push`

## 使用タイミング
- **実装完了後**: 新機能や修正が完了してプッシュしたい時
- **PR作成前**: プルリクエストを作成するためのプッシュ時
- **Lefthookエラー回避**: プッシュ時のhookエラーを事前に防ぎたい時

## 実行方法
```bash
make push
```

## メリット
- **エラーの事前発見**: プッシュ前に問題を発見・修正可能
- **時間節約**: Lefthookエラーによる再作業を回避
- **品質保証**: 一定の品質を保ったコードのみがプッシュされる
- **チーム開発**: 他のメンバーが pull する際の安心感

## エラー対処
品質チェックで問題が発見された場合：
1. エラーメッセージを確認
2. 該当箇所を修正
3. 再度 `make push` を実行

## 緊急時のスキップ方法
**非推奨ですが**、緊急時は以下でスキップ可能：
```bash
# 全hookをスキップ
LEFTHOOK=0 git push

# pre-pushのみスキップ
git push --no-verify
```

## ワークフロー例
```bash
# 1. 実装
# ... コード実装 ...

# 2. 安全なプッシュ
make push

# 3. エラーがあれば修正
# ... エラー修正 ...

# 4. 再度プッシュ
make push
```

## 関連コマンド
- `make check-ready`: プッシュなしで品質チェックのみ実行
- `make format`: フォーマットのみ実行
- `make analyze`: 静的解析のみ実行
- `make test`: テストのみ実行