# DAUトレンド確認

指定アプリのDAUトレンドを取得して可視化してください。

## 引数
- `$ARGUMENTS`: アプリID（例: `crelve-jh-science`）

引数がない場合は、まず全アプリ一覧を表示してユーザーに選択を促す。

## データ取得

**アプリ一覧（引数なしの場合）:**
```
https://us-central1-kikiki-flutter-template-prod.cloudfunctions.net/getMetricsSummary?period=daily
```

**トレンドデータ（appId指定時）:**
```
https://us-central1-kikiki-flutter-template-prod.cloudfunctions.net/getDAUTrend?appId={appId}&days=14
```

## 出力形式

```markdown
## 📈 DAUトレンド - {アプリ名}

**期間**: 過去14日間

### グラフ
日付    | DAU | 
--------|-----|--------
12/24   |  8  | ████████
12/23   |  4  | ████
12/22   |  2  | ██
...

### 統計
- 平均DAU: {数値}
- 最高: {数値}（{日付}）
- 最低: {数値}（{日付}）
- 傾向: 上昇/下降/横ばい
```

## 利用可能なアプリID
- crelve-jh-english
- crelve-jh-science
- crelve-jh-society
- crelve-jh-kanji
- crelve-hs-society
- reading-timer
- diary-habit
- cash-counter
- など
