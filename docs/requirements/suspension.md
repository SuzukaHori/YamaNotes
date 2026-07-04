# 中断機能要件定義書

## 概要

日を跨いで歩いたり長めの休憩をとった場合に、休憩・就寝などの時間が「歩いた時間」に含まれてしまう問題を解決する。ユーザーが明示的に歩行を中断・再開でき、中断期間は経過時間にカウントされないようにする。

## スコープ

- ダッシュボードに「中断する」ボタンを追加し、押すと中断が開始される
- 中断中はダッシュボードに「中断中」ラベルと「再開する」ボタンを表示し、到着ボタンは非表示にする
- 中断中は到着記録の作成をサーバー側でも拒否する（Turbo のキャッシュ画面や直接 POST への防御）
- 中断中は経過時間の表示が中断開始時点で止まる（リアルタイム更新も停止する）
- 中断期間（開始〜終了）は `suspensions` テーブルにレコードとして保存する
- 全ての時間表示（ダッシュボードの経過時間・完走時の所要時間・公開レポート・歩行記録一覧）から中断時間の合計を差し引く
- 1つの歩行記録につき、進行中の中断は同時に1つまで（モデルバリデーション + DB 部分ユニークインデックスの二重防御）
- 中断したままリタイア・完走操作をした場合は、その時点で中断を自動終了する

## スコープ外

- 中断時刻（開始・終了）の後からの編集・削除（将来必要になれば追加する）
- 中断履歴の一覧表示
- 到着時刻の編集と中断期間の整合性チェック（中断は到着記録とは独立したレコードとして扱う）
- 駅間隔からの中断の自動判定（明示的なボタン操作のみ）

---

## 実装方式

### モデル

- `Suspension` モデルを新設する。カラムは `walk_id` / `started_at`（必須） / `ended_at`（NULL 許可）
- `ended_at IS NULL` のレコードの存在が「中断中」を表す（Walk にフラグは持たせず、二重管理を避ける）
- `suspensions.walk_id` に `where: ended_at IS NULL` の部分ユニークインデックスを張り、「進行中の中断は Walk ごとに1つ」を DB レベルでも保証する（`walks.user_id` の active 部分インデックスと同じ手法）
- 経過時間の計算ロジックは `Walk` モデルに集約する（`elapsed_seconds` / `time_to_reach_goal_seconds` / `total_suspended_seconds`）。`WalksHelper` は秒数を文字列に整形するだけの表示専任層にする

### コントローラー

- `Walks::SuspensionsController` を新設（`Walks::DeactivationsController` と同じサブリソースパターン）
  - `POST /walks/:walk_id/suspension` — 中断開始（`started_at: 現在時刻` で作成）
  - `PATCH /walks/:walk_id/suspension` — 再開（進行中の中断に `ended_at: 現在時刻` をセット）
- `Walks::DeactivationsController#create` で、進行中の中断があれば `ended_at` を確定させてから `active: false` にする

### フロントエンド

- `time_controller.js` はサーバーが計算済みの経過秒数（中断控除済み）と稼働中フラグを受け取る方式に変更する。中断中はタイマーを起動せず、サーバーが描画した値が静止表示される
- 中断状態はサーバー（DB）を唯一の情報源とするため、リロードしても表示は正しく復元される

## 挙動

| 状態 | 経過時間表示 | 到着ボタン | 中断/再開ボタン |
|---|---|---|---|
| 歩行中 | リアルタイム更新（中断合計を控除） | 表示 | 「中断する」 |
| 中断中 | 中断開始時点で停止 | 非表示（「中断中」ラベル） | 「再開する」 |
| 完走 | 所要時間 =（ゴール − 出発 − 中断合計） | −（完走画面） | − |
| リタイア | − | − | −（進行中の中断は自動終了） |

## 構成ファイル

- `app/models/suspension.rb` — 中断レコード。バリデーションとスコープ
- `app/models/walk.rb` — `suspended?` / `total_suspended_seconds` / `elapsed_seconds` / `time_to_reach_goal_seconds`
- `app/models/arrival.rb` — 中断中の到着記録作成を拒否するバリデーション
- `app/helpers/walks_helper.rb` — 秒数の文字列整形（計算は Walk に委譲）
- `app/controllers/walks/suspensions_controller.rb` — 中断開始・再開
- `app/controllers/walks/deactivations_controller.rb` — リタイア時の中断自動終了
- `app/views/walks/show.html.slim` / `_walk.html.slim` — ボタン・ラベルの出し分け
- `app/javascript/controllers/time_controller.js` — 経過時間のリアルタイム表示
- `config/locales/models/suspension/{ja,en}.yml` / `config/locales/views/walks/suspensions/{ja,en}.yml` — 翻訳
