# UX Psychology Reference

Claude CodeにUX心理学のコンテキストを与えることで、UI/UX実装品質を向上させます。

> 参考:
> - [UX Psychology - shokasonjuku.com](https://www.shokasonjuku.com/ux-psychology)
> - [Claude CodeのコンテキストにUX心理学を与えたら、UI/UXはどう変わるのか](https://qiita.com/nori0724/items/5c1aa2a5d5327bb68b6c)

---

## Quick Reference Table

| # | コンセプト | 英語名 | 要約 |
|---|-----------|--------|------|
| 1 | [美的ユーザビリティ効果](#1-美的ユーザビリティ効果) | Aesthetic-Usability Effect | 美しいデザインは使いやすく感じる |
| 2 | [アンカー効果](#2-アンカー効果) | Anchor Effect | 最初の情報が基準になる |
| 3 | [バナー・ブラインドネス](#3-バナーブラインドネス) | Banner Blindness | 広告風の要素は無視される |
| 4 | [認知負荷](#4-認知負荷) | Cognitive Load | 情報処理には精神的エネルギーが必要 |
| 5 | [確証バイアス](#5-確証バイアス) | Confirmation Bias | 自分の信念に合う情報を優先 |
| 6 | [好奇心ギャップ](#6-好奇心ギャップ) | Curiosity Gap | 情報の欠如が行動を促す |
| 7 | [決断疲れ](#7-決断疲れ) | Decision Fatigue | 決断の繰り返しで判断力低下 |
| 8 | [おとり効果](#8-おとり効果) | Decoy Effect | 第3の選択肢で誘導 |
| 9 | [デフォルト効果](#9-デフォルト効果) | Default Bias | 人はデフォルトを選びがち |
| 10 | [ドハティの閾値](#10-ドハティの閾値) | Doherty Threshold | 0.4秒以内の応答が重要 |
| 11 | [共感ギャップ](#11-共感ギャップ) | Empathy Gap | 開発者とユーザーの認識差 |
| 12 | [授かり効果](#12-授かり効果) | Endowment Effect | 所有物を過大評価する |
| 13 | [期待バイアス](#13-期待バイアス) | Expectation Bias | 期待が体験評価に影響 |
| 14 | [親近性バイアス](#14-親近性バイアス) | Familiarity Bias | 慣れたUIに親しみを感じる |
| 15 | [段階的要請](#15-段階的要請) | Foot in the Door | 小さな依頼→大きな依頼 |
| 16 | [フレーミング効果](#16-フレーミング効果) | Framing | 伝え方で印象が変わる |
| 17 | [ゲーミフィケーション](#17-ゲーミフィケーション) | Gamification | ゲーム要素でモチベUP |
| 18 | [目標勾配効果](#18-目標勾配効果) | Goal Gradient Effect | ゴール近くで加速する |
| 19 | [ハロー効果](#19-ハロー効果) | Halo Effect | 一部の印象が全体評価に |
| 20 | [観察効果](#20-観察効果) | Hawthorne Effect | 見られると行動が変わる |
| 21 | [ヒックの法則](#21-ヒックの法則) | Hick's Law | 選択肢が多いと迷う |
| 22 | [意図的な壁](#22-意図的な壁) | Intentional Friction | 意図的に遅延させる |
| 23 | [ヤコブの法則](#23-ヤコブの法則) | Jakob's Law | 慣れたパターンを期待 |
| 24 | [労働の錯覚](#24-労働の錯覚) | Labor Illusion | 努力が見えると価値を感じる |
| 25 | [損失回避](#25-損失回避) | Loss Aversion | 損失を避けたい |
| 26 | [ミラーの法則](#26-ミラーの法則) | Miller's Law | 7±2の情報量が限界 |
| 27 | [ナッジ効果](#27-ナッジ効果) | Nudge | 非強制的に誘導 |
| 28 | [ピーク・エンドの法則](#28-ピークエンドの法則) | Peak-End Rule | 最高点と終点で評価 |
| 29 | [プライミング効果](#29-プライミング効果) | Priming | 事前刺激が行動に影響 |
| 30 | [段階的開示](#30-段階的開示) | Progressive Disclosure | 必要な時に情報を表示 |
| 31 | [ピグマリオン効果](#31-ピグマリオン効果) | Pygmalion Effect | 期待が現実になる |
| 32 | [誘導抵抗](#32-誘導抵抗) | Reactance | 制限されると反発 |
| 33 | [反応型オンボーディング](#33-反応型オンボーディング) | Reactive Onboarding | 行動に応じて案内 |
| 34 | [希少性効果](#34-希少性効果) | Scarcity | 限定品は魅力的 |
| 35 | [選択的注意](#35-選択的注意) | Selective Attention | 必要な情報に集中 |
| 36 | [系列位置効果](#36-系列位置効果) | Serial Position Effect | 最初と最後を覚えやすい |
| 37 | [スキューモーフィズム](#37-スキューモーフィズム) | Skeuomorphism | 現実の見た目を模倣 |
| 38 | [社会的証明](#38-社会的証明) | Social Proof | 他者の行動を参考に |
| 39 | [サンクコスト効果](#39-サンクコスト効果) | Sunk Cost Effect | 投資を正当化したい |
| 40 | [誘惑の結びつけ](#40-誘惑の結びつけ) | Temptation Bundling | 好きなこと+苦手なこと |
| 41 | [ユーザー歓喜効果](#41-ユーザー歓喜効果) | User Delight | 喜びや驚きの瞬間 |
| 42 | [変動型報酬](#42-変動型報酬) | Variable Reward | 予測不能な報酬で継続 |
| 43 | [ビジュアル・アンカー](#43-ビジュアルアンカー) | Visual Anchor | 視覚的に注意を引く |
| 44 | [視覚的階層](#44-視覚的階層) | Visual Hierarchy | 優先順位を視覚化 |
| 45 | [フォン・レストルフ効果](#45-フォンレストルフ効果) | Von Restorff Effect | 異なる要素は記憶に残る |
| 46 | [フィッツの法則](#46-フィッツの法則) | Fitts's Law | 大きく近いと操作しやすい |
| 47 | [ツァイガルニク効果](#47-ツァイガルニク効果) | Zeigarnik Effect | 未完了タスクは忘れにくい |

---

## Detailed Concepts

### 1. 美的ユーザビリティ効果
**Aesthetic-Usability Effect**

美しくデザインされたプロダクトは、そうでない場合より使いやすいと感じられる現象。

```dart
// 視覚的に洗練されたUIで信頼感を向上
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [color1.withOpacity(0.1), color2.withOpacity(0.1)],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
  ),
)
```

---

### 2. アンカー効果
**Anchor Effect**

ユーザーが最初に受けた情報を基準にして、後続の情報を評価する傾向。

```dart
// 価格表示で元値を見せる
Column(
  children: [
    Text('¥9,800', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
    Text('¥4,980', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
    Text('49%OFF', style: TextStyle(color: Colors.red)),
  ],
)
```

---

### 3. バナー・ブラインドネス
**Banner Blindness**

ユーザーがWebサイト上の広告バナーを無意識的に無視する現象。

**対策:**
- 重要な情報を広告風のデザインにしない
- コンテンツに溶け込むネイティブ広告を使用
- ユーザーにとって価値のある情報として提示

---

### 4. 認知負荷
**Cognitive Load**

ユーザーが情報を処理し、理解する際にかかる精神的なエネルギー量。

```dart
// 認知負荷を減らす: シンプルなフォーム
Form(
  child: Column(
    children: [
      // 1画面で1つの概念に集中
      Text('まずはメールアドレスを入力', style: AppleTextStyles.headline(context)),
      TextField(decoration: InputDecoration(hintText: 'email@example.com')),
      // 他のフィールドは次のステップへ
    ],
  ),
)
```

---

### 5. 確証バイアス
**Confirmation Bias**

人々が自分の既存の信念に合致する情報を優先的に受け入れる傾向。

**UXへの応用:**
- ユーザーの期待に沿ったフィードバックを提供
- 予想外の結果には丁寧な説明を追加
- パーソナライズされたコンテンツ提供

---

### 6. 好奇心ギャップ
**Curiosity Gap**

ユーザーが情報の欠如を埋めるために興味を持ち、行動を起こす。

```dart
// 続きが気になる表示
Card(
  child: Column(
    children: [
      Text('あなたの診断結果は...'),
      Text('続きを見る', style: TextStyle(color: AppleColors.systemBlue)),
      Icon(Icons.arrow_forward_ios, size: 16),
    ],
  ),
)
```

---

### 7. 決断疲れ
**Decision Fatigue**

ユーザーが繰り返し決断を行うことで、合理的な選択が難しくなる現象。

```dart
// 決断を減らす: デフォルト値を提供
DropdownButton<String>(
  value: selectedValue ?? '推奨設定', // デフォルト値
  items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
)
```

---

### 8. おとり効果
**Decoy Effect**

おとりの選択肢を設けることで、他の選択肢をより魅力的に感じさせる誘導手法。

```dart
// 3つのプランでおとり効果
Row(
  children: [
    PricingCard(title: 'Basic', price: '¥500', features: ['機能A']),
    PricingCard(title: 'Pro', price: '¥1,500', features: ['機能A', '機能B'], isPopular: true), // おすすめ
    PricingCard(title: 'Enterprise', price: '¥1,400', features: ['機能A']), // おとり: Proより高いのに機能少ない
  ],
)
```

---

### 9. デフォルト効果
**Default Bias**

人は変更するインセンティブが魅力的でない限り、デフォルトの値にとどまることが多い。

```dart
// 推奨設定をデフォルトに
SwitchListTile(
  title: Text('プッシュ通知'),
  subtitle: Text('重要なお知らせを受け取る'),
  value: true, // デフォルトでON
  onChanged: (v) => {},
)
```

---

### 10. ドハティの閾値
**Doherty Threshold**

ユーザーが**0.4秒以上**待たされると、興味喪失のリスクが高まる閾値。

```dart
// ストリーミングで即座に応答開始
Stream<String> streamResponse(String message) async* {
  await for (final chunk in aiService.streamMessage(message: message)) {
    yield chunk; // 400ms以内に最初の応答を表示
  }
}

// 即座のフィードバック
GestureDetector(
  onTapDown: (_) {
    HapticFeedback.lightImpact(); // 即座に触覚フィードバック
    setState(() => _isPressed = true);
  },
)
```

**応答時間の目安:**
| 操作 | 目標時間 | 対策 |
|------|---------|------|
| タップフィードバック | < 100ms | HapticFeedback + 視覚変化 |
| UI更新 | < 400ms | 楽観的更新、ローカルキャッシュ |
| データ取得 | < 1000ms | ローディング表示 |
| 長時間処理 | > 1000ms | 進捗バー + 労働の錯覚 |

---

### 11. 共感ギャップ
**Empathy Gap**

デザイナーや開発者がユーザーの感情やニーズに共感できないこと。

**対策:**
- ユーザーテストを実施
- ペルソナを作成し常に参照
- 初心者の気持ちでUIを見直す

---

### 12. 授かり効果
**Endowment Effect**

自分がすでに所有しているものを過剰に評価する傾向。

```dart
// 無料トライアルで所有感を与える
Column(
  children: [
    Text('あなたのプレミアム体験', style: AppleTextStyles.title1(context)),
    Text('残り7日'),
    LinearProgressIndicator(value: 0.3),
    Text('このまま継続して特典を維持しましょう'),
  ],
)
```

---

### 13. 期待バイアス
**Expectation Bias**

事前に持っている期待が、実際の体験評価に影響を与える現象。

**応用:**
- 高品質なオンボーディングで良い第一印象を
- 機能説明で適切な期待値を設定
- 期待を超える小さなサプライズを用意

---

### 14. 親近性バイアス
**Familiarity Bias**

以前に経験したデザインや機能に親しみを感じる傾向。

```dart
// 標準的なナビゲーションパターンを使用
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: '検索'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'マイページ'),
  ],
)
```

---

### 15. 段階的要請
**Foot in the Door Effect**

小さなお願いを受け入れた後、より大きなお願いも受け入れる傾向が高まる。

```dart
// 段階的なエンゲージメント
// Step 1: 簡単な質問に答えてもらう
Text('好きな色を選んでください'),
// Step 2: もう少し詳しく
Text('興味のあるカテゴリを選んでください'),
// Step 3: アカウント作成を依頼
Text('アカウントを作成して保存しましょう'),
```

---

### 16. フレーミング効果
**Framing**

情報の提示方法によって、判断が左右される心理的現象。

```dart
// ポジティブなフレーミング
// ❌ '10%のユーザーが失敗しました'
// ✅ '90%のユーザーが成功しています'

Text('90%のユーザーが目標を達成しています',
  style: TextStyle(color: Colors.green)),
```

---

### 17. ゲーミフィケーション
**Gamification**

ゲームの要素を取り入れて、モチベーション向上を促すアプローチ。

```dart
// 達成バッジ、ポイント、レベルシステム
Row(
  children: [
    Icon(Icons.emoji_events, color: Colors.amber),
    Text('レベル5達成！'),
    Text('+100ポイント獲得'),
  ],
)
```

---

### 18. 目標勾配効果
**Goal Gradient Effect**

ユーザーが目標に近づくにつれ、行動を加速させる心理的な現象。

```dart
// プログレスバーで目標への距離を可視化
Column(
  children: [
    Text('あと2ステップで完了！'),
    LinearProgressIndicator(value: 0.8), // 80%完了
    Text('ゴールまであと少し！', style: TextStyle(color: AppleColors.systemGreen)),
  ],
)
```

---

### 19. ハロー効果
**Halo Effect**

一部の良い印象が、全体の評価を高める現象。

**応用:**
- 最初の画面を特に美しくデザイン
- ブランドの信頼性を可視化
- 有名企業のロゴや推薦を表示

---

### 20. 観察効果
**Hawthorne Effect**

人は観察されていると自覚すると、行動を変える傾向。

**応用:**
- ユーザーテストでは自然な環境を再現
- アナリティクスで実際の行動を計測
- フィードバックと行動データを組み合わせる

---

### 21. ヒックの法則
**Hick's Law**

選択肢が増えると、意思決定に要する時間が対数的に増加する。

```dart
// 選択肢を5-7個以下に制限
Column(
  children: [
    PrimaryButton(label: 'メインアクション'),
    Row(
      children: [
        SecondaryButton(label: 'オプション1'),
        SecondaryButton(label: 'オプション2'),
      ],
    ),
    // 高度な機能は折りたたむ
    ExpansionTile(title: Text('詳細オプション'), children: [...]),
  ],
)
```

---

### 22. 意図的な壁
**Intentional Friction**

ユーザーの行動を意図的に妨げるステップを増やすデザイン手法。

```dart
// 重要な操作には確認ステップを追加
Future<void> deleteAccount() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('本当に削除しますか？'),
      content: Text('この操作は取り消せません'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('キャンセル')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text('削除', style: TextStyle(color: Colors.red))),
      ],
    ),
  );
  if (confirmed == true) { /* 削除処理 */ }
}
```

---

### 23. ヤコブの法則
**Jakob's Law**

ユーザーは他のアプリで慣れ親しんだパターンを期待する。

```dart
// 標準的なジェスチャーを尊重
// - 左スワイプで戻る
// - プルトゥリフレッシュ
// - ピンチでズーム
RefreshIndicator(
  onRefresh: () async => await fetchData(),
  child: ListView(...),
)
```

---

### 24. 労働の錯覚
**Labor Illusion**

サービスが労力や時間がかかっているように見せると、ユーザーが価値を高く感じる現象。

```dart
// 「考え中」表示で価値を演出
class ThinkingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        SizedBox(width: 8),
        Text('AIが最適な回答を生成中...', style: AppleTextStyles.footnote(context)),
      ],
    );
  }
}
```

**効果的な表示例:**
- 「AIが最適な回答を生成中...」
- 「1,000件以上のデータから分析中...」
- 「セキュリティを確認中...」

---

### 25. 損失回避
**Loss Aversion**

ユーザーは利益を得るよりも損失を避けたいという感情が強い。

```dart
// 損失を強調して行動を促す
Column(
  children: [
    Text('⚠️ 本日限りの特別価格', style: TextStyle(color: Colors.red)),
    Text('明日から通常価格に戻ります'),
    Text('この機会を逃すと¥5,000の損失'),
  ],
)
```

---

### 26. ミラーの法則
**Miller's Law**

人間の短期記憶は**7±2個**の情報チャンクしか保持できない。

```dart
// 情報を7個以下のチャンクに分割
ListView(
  children: [
    SectionHeader('アカウント'), // グループ1
    ListTile(title: Text('プロフィール')),
    ListTile(title: Text('セキュリティ')),

    SectionHeader('設定'), // グループ2
    ListTile(title: Text('通知')),
    ListTile(title: Text('テーマ')),
  ],
)
```

---

### 27. ナッジ効果
**Nudge**

ユーザーの意思決定を、非強制的に望ましい方向に誘導するデザイン手法。

```dart
// デフォルトで推奨オプションを選択
RadioListTile(
  title: Text('年間プラン（2ヶ月分お得）'),
  subtitle: Text('おすすめ'),
  value: 'yearly',
  groupValue: _selected,
  selected: true, // デフォルトで選択
)
```

---

### 28. ピーク・エンドの法則
**Peak-End Rule**

体験の評価は、最高の瞬間（ピーク）と終わりの瞬間（エンド）を重視する。

```dart
// 完了時のお祝い演出
class CompletionCelebration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/success.json'),
        SizedBox(height: 24),
        Text('おめでとうございます！', style: AppleTextStyles.title1(context)),
        Text('設定が完了しました'),
      ],
    );
  }
}
```

---

### 29. プライミング効果
**Priming**

あらかじめ受けた刺激によって、その後の行動が影響されること。

**応用:**
- オンボーディングで期待値を設定
- 関連性のある画像やアイコンを使用
- ポジティブな言葉を先に表示

---

### 30. 段階的開示
**Progressive Disclosure**

情報や機能を段階的に表示して、必要な時に必要な情報にアクセスできるようにする。

```dart
// 詳細は折りたたんで表示
ExpansionTile(
  title: Text('詳細設定'),
  children: [
    // 高度な設定項目
    ListTile(title: Text('キャッシュをクリア')),
    ListTile(title: Text('デバッグモード')),
  ],
)
```

---

### 31. ピグマリオン効果
**Pygmalion Effect**

ユーザーがプロダクトに対して期待を持つと、その期待が現実となる傾向。

**応用:**
- ユーザーの目標達成を支援するメッセージ
- 「あなたならできる」という励まし
- 過去の成功を振り返らせる

---

### 32. 誘導抵抗
**Reactance**

ユーザーが制約や制限を感じたときに生じる心理的反発。

**対策:**
- 強制ではなく選択肢を提供
- 制限の理由を明確に説明
- 代替手段を用意

---

### 33. 反応型オンボーディング
**Reactive Onboarding**

ユーザーの行動やニーズに応じて表示されるオンボーディングプロセス。

```dart
// コンテキストに応じたヒント表示
if (isFirstTimeUsingFeature) {
  showTooltip(
    message: 'ここをタップして新規作成',
    target: addButton,
  );
}
```

---

### 34. 希少性効果
**Scarcity**

入手が難しいと感じる状況で、商品に対して高い価値を見出す効果。

```dart
// 限定感を演出
Row(
  children: [
    Icon(Icons.timer, color: Colors.red),
    Text('残り3時間', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
  ],
)

Text('在庫残り2点', style: TextStyle(color: Colors.orange)),
```

---

### 35. 選択的注意
**Selective Attention**

情報過多の状況下でも、目的に沿った情報に集中する傾向。

**応用:**
- 重要な情報を視覚的に強調
- 不要な情報を削減
- ユーザーの目的を理解してコンテンツを整理

---

### 36. 系列位置効果
**Serial Position Effect**

リストの最初と最後に位置する項目が、中間より記憶しやすくなる傾向。

```dart
// 重要な項目を最初と最後に配置
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'), // 最初
    BottomNavigationBarItem(icon: Icon(Icons.search), label: '検索'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'マイページ'), // 最後
  ],
)
```

---

### 37. スキューモーフィズム
**Skeuomorphism**

デジタルインターフェース上の物体が現実世界の見た目を模倣するデザイン手法。

**応用:**
- 直感的に理解できるアイコンデザイン
- 現実のメタファーを活用（ゴミ箱、フォルダなど）
- ただし過度な装飾は避ける

---

### 38. 社会的証明
**Social Proof**

他者の意見や行動に影響を受ける心理現象。

```dart
// レビューと評価を表示
Row(
  children: [
    Icon(Icons.star, color: Colors.amber),
    Text('4.8'),
    Text('（2,345件のレビュー）', style: TextStyle(color: Colors.grey)),
  ],
)

Text('12,000人以上が利用中', style: AppleTextStyles.footnote(context)),
```

---

### 39. サンクコスト効果
**Sunk Cost Effect**

過去に投資した資源を正当化しようと、さらなる資源を投入する心理的傾向。

```dart
// 投資した時間や努力を可視化
Column(
  children: [
    Text('これまでの学習時間: 24時間'),
    Text('獲得バッジ: 15個'),
    Text('ここで辞めるのはもったいない！'),
    PrimaryButton(label: '続ける'),
  ],
)
```

---

### 40. 誘惑の結びつけ
**Temptation Bundling**

好きな活動と苦手なタスクを一緒に行うことで、難しいタスクへの取り組みを容易にする。

```dart
// ゲーミフィケーションと組み合わせ
Column(
  children: [
    Text('今日の学習を完了すると...'),
    Row(
      children: [
        Icon(Icons.lock_open, color: Colors.amber),
        Text('限定スタンプをゲット！'),
      ],
    ),
  ],
)
```

---

### 41. ユーザー歓喜効果
**User Delight**

プロダクトを使用することで感じる喜びや驚きの瞬間。

```dart
// 予想外の嬉しいサプライズ
if (completedTasksToday >= 5) {
  showCelebration(
    title: 'すごい！',
    message: '今日5つのタスクを完了しました！',
    animation: 'confetti.json',
  );
}
```

---

### 42. 変動型報酬
**Variable Reward**

報酬の大きさや頻度が予測できないことで、興味や継続性を高める効果。

```dart
// ランダムな報酬で継続を促進
final rewards = ['10ポイント', '50ポイント', 'レアバッジ', '特別クーポン'];
final randomReward = rewards[Random().nextInt(rewards.length)];

showDialog(
  builder: (_) => AlertDialog(
    title: Text('おめでとう！'),
    content: Text('$randomReward を獲得しました！'),
  ),
);
```

---

### 43. ビジュアル・アンカー
**Visual Anchor**

視覚的な強調を利用して、ユーザーの注意を特定の要素に引き付ける原則。

```dart
// CTAボタンを視覚的に強調
Stack(
  children: [
    content,
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.white],
          ),
        ),
        child: PrimaryButton(label: '今すぐ始める'), // 視覚的アンカー
      ),
    ),
  ],
)
```

---

### 44. 視覚的階層
**Visual Hierarchy**

デザイン要素を配置し、視覚的に優先順位を付けること。

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('プレミアムプラン', style: AppleTextStyles.largeTitle(context)), // 最重要
    SizedBox(height: 8),
    Text('すべての機能にアクセス', style: AppleTextStyles.body(context)), // 重要
    SizedBox(height: 16),
    Text('月額¥980', style: AppleTextStyles.title1(context).copyWith(color: AppleColors.systemBlue)),
    SizedBox(height: 4),
    Text('年間プランなら2ヶ月分お得', style: AppleTextStyles.footnote(context)), // 補足
  ],
)
```

---

### 45. フォン・レストルフ効果
**Von Restorff Effect（分離効果）**

他と異なる要素は記憶に残りやすい。

```dart
// CTAボタンを視覚的に差別化
Row(
  children: [
    SecondaryButton(label: 'キャンセル'),
    SizedBox(width: 12),
    PrimaryButton(label: '購入する'), // 差別化されたCTA
  ],
)
```

---

### 46. フィッツの法則
**Fitts's Law**

ターゲットへの移動時間は、距離に比例し、サイズに反比例する。

```dart
// タップターゲットは44pt以上
SizedBox(
  width: 44,
  height: 44,
  child: IconButton(icon: Icon(Icons.close), onPressed: () {}),
)

// 重要なボタンは画面下部（親指が届きやすい）に配置
Scaffold(
  body: content,
  bottomNavigationBar: SafeArea(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: PrimaryButton(label: '次へ'),
    ),
  ),
)
```

---

### 47. ツァイガルニク効果
**Zeigarnik Effect**

未完了のタスクは完了したタスクよりも記憶に残りやすい。

```dart
// プログレスバーで完了度を表示
Column(
  children: [
    Text('プロフィール完成度: 70%'),
    LinearProgressIndicator(value: 0.7),
    TextButton(onPressed: () {}, child: Text('あと少しで完成！')),
  ],
)
```

---

## Implementation Checklist

### 応答性（Responsiveness）
- [ ] タップフィードバックは100ms以内
- [ ] UI更新は400ms以内（ドハティの閾値）
- [ ] 長時間処理にはプログレス表示（労働の錯覚）

### 情報設計（Information Architecture）
- [ ] 選択肢は5-7個以下（ヒックの法則）
- [ ] 情報は7±2チャンクに分割（ミラーの法則）
- [ ] 重要な項目を最初と最後に配置（系列位置効果）
- [ ] 段階的開示で複雑さを管理

### 操作性（Usability）
- [ ] タップターゲットは44pt以上（フィッツの法則）
- [ ] 重要なボタンは画面下部に配置
- [ ] 標準的なUIパターンを使用（ヤコブの法則）
- [ ] デフォルト値を適切に設定（デフォルト効果）

### 感情的体験（Emotional Experience）
- [ ] 美しいデザインで信頼感を向上（美的ユーザビリティ効果）
- [ ] 完了時のお祝い演出（ピーク・エンドの法則）
- [ ] CTAを視覚的に差別化（フォン・レストルフ効果）
- [ ] 進捗表示で継続を促す（ツァイガルニク効果、目標勾配効果）

### 説得設計（Persuasive Design）
- [ ] 社会的証明を表示（レビュー、利用者数）
- [ ] 希少性を適切に活用（限定感）
- [ ] ポジティブなフレーミング
- [ ] 損失回避を意識した表現

---

## Related References

- [Colors](colors.md) - カラーシステム
- [Typography](typography.md) - テキストスタイル
- [Components](components.md) - UIコンポーネント
- [Animations](animations.md) - アニメーション
- [Spacing](spacing.md) - レイアウト

## External Resources

- [UX Psychology - shokasonjuku.com](https://www.shokasonjuku.com/ux-psychology)
- [Laws of UX](https://lawsofux.com/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
