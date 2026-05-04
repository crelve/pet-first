# 📋 Phase別実行ガイド

## 情報フロー設計（重要）

### 3層アーキテクチャ

```
company/planning/specs/  = 意思決定（WHY + WHATの方針）
    │
    │ 企画書を「入力」として参照（読むだけ）
    ▼
flutter-template Phase 1-8 = 変換エンジン（HOWのルール）
    │
    │ docs/project/ を「生成」（書き出すだけ）
    ▼
app-repo/docs/project/  = 実行可能な真実（唯一の参照先）
```

### ルール
- **情報は上から下に一方向。逆流・重複禁止**
- 企画書 → app-repo への直接コピー禁止。必ずPhaseを経由する
- 価格・Firebase構成等の共通ルールの真実はflutter-templateに1箇所だけ
- 開発部は `docs/project/` のみ参照。企画書は見ない

### 企画書がある場合 vs ない場合

全Phaseは冒頭で `company/planning/specs/{app-name}-spec.md` の存在を確認する。

| 状況 | 動作 |
|------|------|
| **企画書あり** | 企画書の値を採用し、足りない部分だけ自動生成 |
| **企画書なし** | ゼロから全て自動生成（従来の動作） |

### 企画書のスコープ（companyリポ側のルール）

企画書は100-150行。GO/NO-GO判断に必要な情報のみ。
画面設計・データモデル・価格計算等の実装詳細はPhaseが生成する。

---

## ファイル構造

```
01-phases/
├── _common/
│   └── ai-capabilities.md   # AI機能対応表（共通参照）
├── phase1-idea.md           # アイデア探索（7軸評価）
├── phase2-app-naming.md     # アプリ名・多言語設定
├── phase3-market.md         # 競合深掘り調査
├── phase4-business.md       # ビジネス設計（最終1案選定）
├── phase5-tech.md           # 技術設計（Firebase構成）
├── phase6-requirements.md   # 要件定義（ハイブリッド方式）
├── phase7-design.md         # 仕様書作成（Mermaid図）
└── phase8-repo.md           # リポジトリ構築（GitHub）
```

---

## 実行順序

| Phase | 内容 | 企画書ありの場合 |
|-------|------|-----------------|
| 1 | アイデア探索・選定 | 1案確定済み。7軸評価のみ |
| 2 | アプリ名決定・39言語設定 | アプリ名確定済み。ARB生成から |
| 3 | 競合深掘り調査 | 1案の深掘りに集中 |
| 4 | ビジネス設計 | 月額から年額・買い切りを算出 |
| 5 | 技術設計（Firebase） | 通常通り |
| 6 | 要件定義（EARS+画面仕様） | MVP機能リストを起点に詳細化 |
| 7 | 仕様書作成（design/tasks） | 通常通り |
| 8 | リポジトリ構築（GitHub） | 通常通り |

---

## トークン効率化ルール

### Phase別読み込み（必須）
```
現在実行中のPhaseファイルのみ読み込む
❌ 全Phase一括読み込み禁止
```

### メモリ活用
```
Phase 1: WebSearch結果をメモリ保存
Phase 2-8: メモリから情報取得（再検索不要）
```

### 並列実行
```
Phase 3: 競合分析を同時WebSearch
```

