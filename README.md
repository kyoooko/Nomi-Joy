![Nomi-Joy_letter](https://user-images.githubusercontent.com/60662524/88514554-44829f80-d025-11ea-8dc3-166964a86d2f.png)

![twitter-card](https://user-images.githubusercontent.com/60662524/88530963-19a44580-d03d-11ea-8ca6-8513ace6d7a3.png)

## 概要
「ノミカイの準備を便利に、楽しく」

幹事さんと参加者双方に向けた、飲み会の準備を便利に楽しくサポートするサービスです。

## URL
https://nomi-joy.com

「かんたんログイン」ボタンからテストユーザーとしてログインできます。幹事側へは、参加者側からログイン後「カンジの部屋」のロゴマークから入室できます。

## 制作の背景
前職で会社の飲み会の幹事をすることがありましたが、出欠や会費徴収の管理が大変でした。

また送別会のシーズンになると飲み会が月に何件も重なり、「どの飲み会をどこまで準備できているんだっけ？」「○○さんからこの前の会費をまだいただいてないけど目上の方だから何度もお願いしにくいな・・・」「○○さんが欠席したのはどの飲み会だったっけ？」などと混乱してしまうことがありました。

幹事をしてこのように大変な経験をした人は多いはず・・・そのような人たちが少しでも「便利にかつ楽しく」飲み会の準備をできたら、という思いからこのサービスを制作しました。同時に、参加者の方にとっても便利に利用できるサービスを目指しました。

## 主な利用シーン
飲み会の準備期間中〜集金完了まで

【幹事側】
* 会社の飲み会（中〜大人数規模）の幹事として、決定事項の記録、参加者への情報共有、会費の集金管理をしたいとき
* 幹事をする飲み会が多数あり、それぞれの進捗管理を行いたいとき

【参加者側】
* 飲み会の情報（場所、会費など）を確認したいとき
* 幹事に連絡をしたいとき （欠席や遅刻の連絡など）

## 機能一覧
* 通知機能 （フォローされた時、DMが届いた時、幹事が支払い依頼ボタンを押した時に通知が来る）
* DM機能 （非同期通信）
* 検索機能 （非同期通信／ぐるなびAPIを使用し店舗検索、保存）
* マップ表示 （ぐるなびAPIにて取得した住所から表示）
* カレンダー表示(保存した飲み会情報を表示)
* マッチング（フォロー）機能 （非同期通信）
* レスポンシブデザイン

![README-responsive](https://user-images.githubusercontent.com/60662524/88524761-bb736480-d034-11ea-94d1-dcfec3fc4266.png)

詳細は下記よりご確認ください。

https://docs.google.com/spreadsheets/d/1zn1J7OT1fU9TOgGupXXd03vXP6VqDejtVFZ6z9pqhcQ/edit#gid=1830135488

## 環境・使用技術
### フロントエンド
* Bootstrap4
* Scss(BEM)
* JavaScript, jQuery,Ajax

### バックエンド
* Ruby 2.5.7
* Rails 5.2.4.3

### 開発環境
* Vagrant 2.2.4

### 本番環境
* MySQL2
* AWS (EC2, RDS for MySQL,Route53)
* Nginx, Puma
* Capistrano

### その他
* ぐるなびAPI
* Google MapAPI、Geocoding API
* HTTPS接続(Certbot)
* Rubocop

## ER図
https://drive.google.com/file/d/1qWo_DcQI12CA0tIKWqu1P8B3I4GlSt2q/view?usp=sharing

