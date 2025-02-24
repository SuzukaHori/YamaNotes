<!-- @format -->

# YamaNotes

## サービス概要

山手線一周に徒歩で挑戦する人向けの記録アプリです。

## URL

https://www.yamanotes.com

## できること

### 進捗表示

現在の進捗を地図で表示します。残りの駅数や距離などを、計算する必要がありません。
<img width="1184" alt="ダッシュボードのキャプチャ" src="https://github.com/SuzukaHori/YamaNotes/assets/129706209/4a23d1af-2498-4956-b906-1eaee33d2676">

### 到着記録

「到着」ボタンを押すことで、時間と駅を記録できます。記録した情報は、Xに投稿することもできます。
<img width="1188" alt="到着画面のキャプチャ" src="https://github.com/SuzukaHori/YamaNotes/assets/129706209/8b973b18-e7d8-407c-9ce5-9719820a119e">

### 一覧表示

到着時刻の記録やメモを、一覧で見ることができます。編集や削除もできます。
<img width="1182" alt="履歴画面のキャプチャ" src="https://github.com/SuzukaHori/YamaNotes/assets/129706209/dca34d4f-048e-496a-828d-160551f4944f">

## 動作環境

- Ruby 3.4.2
- Ruby on Rails 8.0.0
- Hotwire

## 環境変数

|  名称  |  説明  |
| :---: | :---:|
| GOOGLE_CLIENT_ID | GoogleのクライアントID  |
| GOOGLE_CLIENT_SECRET  | Googleのクライアントシークレット |
| FONTAWESOME_URL | Font AwesomeのCDNコード |
| MAPTAILER_KEY | MapTailerのアクセストークン |

## インストールと起動

```bash
$ git clone
$ cd YamaNotes
$ cp .env.example .env
$ vi .env # set your secret keys
$ bin/setup
$ bin/dev
$ open http://localhost:3000/
```

## Lint/Test

- Lint
  ```bash
  $ bin/lint
  ```
- Test
  ```bash
  $ bundle exec rspec
  ```
