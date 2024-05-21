# YamaNotes
## サービス概要
山手線一周に徒歩で挑戦する人向けの、到着駅や到着時間の記録アプリです。

## できること
- 到着ボタンを押すと、到着駅と時間を記録し、残りの駅数や距離を取得します。
- 駅に到着時にポストボタンを押すと、Xに投稿できます。
- 駅のメモを追加します。メモは後から編集することもできます。
- 到着時刻の記録やメモを、一覧で見ることができます。
- 公開機能をONにしてURLをシェアすることで、自分の記録を他の人と共有できます。

## URL
```
https://yamanotes.onrender.com/
```

## 動作環境
- Ruby 3.3.0
- Ruby on Rails 7.1.3.2
- Hotwire


## 環境変数
|  名称  |  説明  |
| :---: | :---:| 
| GOOGLE_CLIENT_ID | GoogleのクライアントID  |
| GOOGLE_CLIENT_SECRET  | Googleのクライアントシークレット |
| FONTAWESOME_URL | Font AwesomeのCDNコード |
| MAPTAILER_KEY | MapTailerのアクセストークン |

## インストールと起動
```zsh
$ git clone
$ cd YamaNotes
$ bin/setup
$ bin/dev
```

## Lint/Test
- Lint
  ```zsh
  $ bin/lint
  ```
- Test
  ```zsh
  $ bundle exec rspec
  ```
