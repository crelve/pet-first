# アプリ詳細メトリクス

指定アプリの詳細メトリクスを取得してください。

## 引数
- `$ARGUMENTS`: アプリID（例: `crelve-jh-science`）

引数がない場合は、全アプリ一覧を表示してユーザーに選択を促す。

## データ取得

```
https://us-central1-kikiki-flutter-template-prod.cloudfunctions.net/getMetrics?appId={appId}&period=daily&includeTrend=true&includeRevenue=true&includeDownloads=true
```

## 出力形式

```markdown
## 📱 {アプリ名} - 詳細メトリクス

### ユーザー指標
| 指標 | 値 | 前週比 |
|-----|-----|-------|
| DAU | {数値} | {変化率}% |
| 新規ユーザー | {数値} | - |
| セッション数 | {数値} | - |
| 画面表示数 | {数値} | - |

### 収益（取得可能な場合）
| 指標 | 値 |
|-----|-----|
| 推定収益 | ¥{数値} |
| インプレッション | {数値} |
| クリック数 | {数値} |
| eCPM | ¥{数値} |

### ダウンロード（取得可能な場合）
| 指標 | 値 |
|-----|-----|
| 日次DL | {数値} |
| 再DL | {数値} |
| 累計DL | {数値} |

### 7日間トレンド
{日別グラフ}
```
