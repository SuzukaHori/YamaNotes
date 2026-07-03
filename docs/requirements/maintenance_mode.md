# メンテナンスモード要件定義書

## 概要

システムのメンテナンス作業時に、環境変数だけで全ユーザーからのアクセスを一時的に遮断し、メンテナンス中の案内ページ（503）を表示できるようにする。

## スコープ

- 環境変数 `MAINTENANCE=1` のときにメンテナンスモードを有効化する（`0`・未設定は無効）
- メンテナンスモード中は、`ApplicationController` を継承する全コントローラのリクエストに対して HTTP 503 とメンテナンス案内ページを返す
- 認証（`authenticate_user!`）より前に遮断するため、未ログインでもメンテナンスページを表示する
- ヘルスチェック用エンドポイント `/up`（`Rails::HealthController`。`ApplicationController` を継承しない）は対象外となり、メンテナンス中も 200 を返す
- デプロイ先は VPS / 自前サーバーを前提とする（Heroku 等のプラットフォーム機能には依存しない）

## スコープ外

- 特定 IP のみアクセスを許可する仕組み（将来必要になれば追加する）
- 管理画面からの ON/OFF 切り替え（環境変数の設定・再起動で運用する）
- アクセス集中時の 503（従来どおり `public/503.html` が使われる。メンテナンスとは別物）

---

## 実装方式

`ApplicationController` の `before_action` で環境変数を判定し、有効時はメンテナンスページをレンダリングして処理を打ち切る。

- `authenticate_user!` より前に宣言することで、認証前に遮断し、未ログインでもメンテナンスページを表示する
- 静的ページ（HighVoltage）や各コントローラは全て `ApplicationController` を継承するため、まとめて遮断できる

## 挙動

| 環境変数 | 対象 | 応答 |
|---|---|---|
| `MAINTENANCE` 未設定 / `0` | すべて | 通常どおり処理する |
| `MAINTENANCE=1` | `ApplicationController` 継承下の全アクション | 503 + メンテナンスページ |
| `MAINTENANCE=1` | `/up`（ヘルスチェック） | 200（対象外） |

## 構成ファイル

- `app/controllers/application_controller.rb` — `maintenance?` 判定と `render_maintenance`
- `app/views/pages/maintenance.html.slim` — メンテナンス案内ページ（レイアウトなし）
- `config/locales/views/pages/{ja,en}.yml` — メンテナンスページの文言

## 運用手順

```bash
# メンテナンス開始（環境変数を設定して再起動）
MAINTENANCE=1 でアプリを起動 / 再起動する

# メンテナンス終了
MAINTENANCE を 0 または未設定に戻して再起動する
```
