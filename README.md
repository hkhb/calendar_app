# calendar_app

URL = https://calendarapp.catry.jp

## 概要
シフト勤務に特化したカレンダーアプリです。  
シフトの入力や管理を、直感的なカレンダーUIで効率化します。

## 機能一覧
- カレンダー表示
- シフト入力
- シフトの一括入力・編集
- ユーザー編集機能

## 使用技術
### フロントエンド
- javascript
- HTML / CSS

### バックエンド
- ruby
- Ruby on Rails
  
### その他
- SQLite3
- simple_calendar（カレンダー表示）
- sassc（CSS適用問題の解決に利用）

## 画面キャプチャ
準備中

## 工夫した点・苦労した点
### 工夫
- シフト入力の手間削減
  - 一括入力ページの提供
  - 時間帯プリセットでの効率的入力
- UIのわかりやすさを意識した設計
### 苦労
- シフトデータとカレンダーの連携（テーブル構造が別だったため）
- simple_calendar のCSSが適用されない問題
  - `sassc` の導入で解決  
    詳細：[Qiita記事](https://qiita.com/hkhb/items/efc5207112db75184358)

## 今後の改善点（ToDo）
- 他ユーザーとの予定共有機能

## ライセンス

MIT
