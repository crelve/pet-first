# 🚀 release:step:08-requirements-check モジュール構成

## トークン効率化のための4モジュール分割構造

`/release:step:08-requirements-check` コマンドは、トークン消費を最小化するため、4つのモジュールに分割されています。

---

## 📁 ファイル構造

```
08-requirements-check-modules/
├── README.md                 # このファイル
├── issue-mapping.md          # GitHub Issue連携チェック
├── basic-checks.md           # 基本適合性チェック
├── feature-checks.md         # 機能特化チェック（認証/データ/UI/通知）
└── issue-automation.md       # Issue自動操作（作成/クローズ）
```

---
