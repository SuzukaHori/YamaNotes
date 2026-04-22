# 到着履歴への画像アップロード要件定義書

## 概要

到着履歴に画像を添付できるようにする。到着した駅の写真などをアップロードし、履歴一覧で確認できる。

## スコープ

- 到着 1 件につき画像 1 枚を添付・削除できる
- アップロード可能なファイル形式は PNG / JPEG のみ（保存時に WebP へ自動変換）
- アップロード時に画像サイズを 5MB 以下に制限する
- 保存時に 400×400 以内にリサイズする
- ストレージは Cloudflare R2 を使用する
- `FeatureFlag.enabled?(:image_upload)` で機能の ON/OFF を制御する（段階リリース対応）

---

## ストレージサービスの選定

### 選択肢の比較

| サービス | 無料枠 | ストレージ単価 | エグレス（ダウンロード）料金 |
|---|---|---|---|
| **Cloudflare R2** | **10GB + 100万 req/月** | **$0.015/GB** | **無料** |
| AWS S3 | なし（12ヶ月トライアルのみ） | $0.023/GB | 有料 |
| Google Cloud Storage | 5GB/月 | $0.020/GB | 有料 |

### 想定コスト試算（月 100 名 × 30 枚 × 300KB）

- ストレージ使用量: 約 900MB/月 → 無料枠（10GB）の 1/10 以下
- リクエスト数: 約 45,000 回/月 → 無料枠（100 万回）の 1/20 以下

### 決定: Cloudflare R2

無料枠内に収まる見込み。また、S3 では画像を表示するたびにダウンロード通信料金が発生するが、R2 は無料のため、アクセスが増えても費用が増えない。

---

## 実装詳細

### モデル

- `Arrival` に `has_one_attached :image` を追加

### コントローラー

- 画像のアップロードは `ArrivalsController#update` で処理（`attach_image` メソッド経由）
- 画像の削除は `Arrivals::ImagesController#destroy` で処理
- 画像処理ロジックは `app/models/arrival/image.rb` の `Arrival::Image` モジュールに集約

### ストレージ設定

`config/storage.yml` に以下を追加:

```yaml
cloudflare:
  service: S3
  access_key_id: <%= ENV["CLOUDFLARE_R2_ACCESS_KEY_ID"] %>
  secret_access_key: <%= ENV["CLOUDFLARE_R2_SECRET_ACCESS_KEY"] %>
  endpoint: <%= ENV["CLOUDFLARE_R2_ENDPOINT"] %>
  bucket: <%= ENV["CLOUDFLARE_R2_BUCKET"] %>
  region: auto
  force_path_style: true
  request_checksum_calculation: when_required
  response_checksum_validation: when_required
```

必要な環境変数:

- `CLOUDFLARE_R2_ACCESS_KEY_ID`
- `CLOUDFLARE_R2_SECRET_ACCESS_KEY`
- `CLOUDFLARE_R2_ENDPOINT`
- `CLOUDFLARE_R2_BUCKET`

使用 gem: `aws-sdk-s3`、`image_processing`、`ruby-vips`

### フロントエンド

- `app/javascript/controllers/image_preview_controller.js`（Stimulus）でファイル選択時のプレビューとキャンセルを実装
- 画像添付フォームは `arrivals/edit` ビューに配置
- 画像は `arrivals/index` ビューの各到着行に表示（最大 280×400 でリサイズ）

---

## 参考

- PoC: https://github.com/SuzukaHori/YamaNotes/pull/303
- [Rails ガイド - Active Storage の概要](https://railsguides.jp/active_storage_overview.html)
- [Rails 8 で Cloudflare R2 を使う](https://zenn.dev/dai199/articles/rails8-cloudflare-r2)

## PR 作成時の注意

- PoC のリンクを概要に含める
- ラベルに `image-upload` を付ける
