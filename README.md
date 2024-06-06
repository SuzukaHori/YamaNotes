# YamaNotes
## サービス概要
山手線一周に徒歩で挑戦する人向けの記録アプリです。

## URL
```
https://www.yamanotes.com
```

## できること
### 進捗表示
現在の進捗を地図で表示します。残りの駅数や距離などを、計算する必要がありません。
![Image](https://github.com/SuzukaHori/YamaNotes/assets/129706209/92ec84b3-94e1-4a9b-95fb-0b286cecc2fb)

### 記録
「到着」ボタンを押すことで、時間と駅を記録できます。記録した情報は、Xに投稿することもできます。
![Image](https://github.com/SuzukaHori/YamaNotes/assets/129706209/d96437a0-2c8c-4a3c-8d71-4e4158932897)

### 一覧表示
到着時刻の記録やメモを、一覧で見ることができます。編集や削除もできます。
![Image](https://github.com/SuzukaHori/YamaNotes/assets/129706209/ba2083d7-7a9f-4812-9a1c-58fe676bf340)

## 動作環境
- Ruby 3.3.0
- Ruby on Rails 7.1.3.3
- Hotwire


## 環境変数
|  名称  |  説明  |
| :---: | :---:| 
| GOOGLE_CLIENT_ID | GoogleのクライアントID  |
| GOOGLE_CLIENT_SECRET  | Googleのクライアントシークレット |
| FONTAWESOME_URL | Font AwesomeのCDNコード |
| MAPTAILER_KEY | MapTailerのアクセストークン |

## インストールと起動
```
$ git clone
$ cd YamaNotes
$ bin/setup
$ bin/dev
```

## Lint/Test
- Lint
  ```
  $ bin/lint
  ```
- Test
  ```
  $ bundle exec rspec
  ```
