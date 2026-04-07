# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

YamaNotes は山手線一周徒歩チャレンジの記録アプリ。Ruby on Rails + Hotwire (Turbo/Stimulus) + TailwindCSS で構築されている。

## Commands

```bash
# 開発サーバー起動
bin/dev

# セットアップ
bin/setup

# テスト
bundle exec rspec

# Lint (rubocop -a + slim-lint + prettier + eslint)
bin/lint

# 個別 Lint
bundle exec rubocop -a
bundle exec slim-lint app/views -c config/slim_lint.yml
npm run fix    # prettier --write
npm run lint   # prettier --check + eslint
```

## Architecture

### Domain Model

- **User**: Google OAuth 認証のみ (devise + omniauth)。一人一つの active な Walk しか持てない
- **Walk**: 一周チャレンジの記録単位。`clockwise`(時計回り/反時計回り)と`active`/`publish`フラグを持つ。`finished?`は到着数が駅数を超えたかで判定
- **Station**: 山手線30駅の固定マスタデータ。`clockwise_next_station_id`で環状に連結された自己参照構造。`Station.cache_all`/`cache_count`でRailsキャッシュ(12時間)を使用
- **Arrival**: Walk と Station の中間テーブル。到着時刻とメモを保持。削除は最後の到着のみ可能、次駅以外への到着記録は禁止

### Controller Structure

- `ApplicationController`: `authenticate_user!` と `current_walk`(active な Walk を返すヘルパー) を定義
- `WalksController`: ダッシュボード表示・Walk の作成/終了。`gon` gem で MAPTAILER_KEY をフロントエンドに渡す
- `ArrivalsController`: 到着の記録・編集・削除
- `walks/DeactivationsController`: Walk の終了(active → false)
- `walk/ArrivalsController` / `public/walks/ArrivalsController`: 履歴一覧表示(後者はログイン不要の公開ページ)

### Frontend

- Stimulus controllers: `map_controller.js`(MapTiler + Leaflet で地図表示)、`time_controller.js`、`modal_controller.js`、`clipboard_controller.js` など
- View テンプレートは Slim 形式
- JavaScript は importmap で管理(webpackなし)

### Key Constraints

- `Arrival`の`arrived_at`は保存時に秒を切り捨て(`beginning_of_minute`)
- メモの`memo`フィールドはURLの後にスペースを自動挿入(rinku gem との互換性のため)
- 到着は必ず隣駅のみ可能(時計回り/反時計回りで方向が変わる)

## Development Workflow

- 作業開始時は必ず専用ブランチを作成する。main ブランチでの作業は禁止
- コミットメッセージは日本語で書く
- PR 作成時は「概要・変更内容・テスト方法」を記載する
- 新機能実装時は要件定義書を作成してから実装を始める

## Environment Variables

| 変数名 | 説明 |
|---|---|
| `GOOGLE_CLIENT_ID` | Google OAuth クライアントID |
| `GOOGLE_CLIENT_SECRET` | Google OAuth クライアントシークレット |
| `FONTAWESOME_URL` | Font Awesome CDN URL |
| `MAPTAILER_KEY` | MapTiler アクセストークン |
