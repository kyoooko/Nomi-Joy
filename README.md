![Nomi-Joy_letter](https://user-images.githubusercontent.com/60662524/88514554-44829f80-d025-11ea-8dc3-166964a86d2f.png)

![twitter-card](https://user-images.githubusercontent.com/60662524/88530963-19a44580-d03d-11ea-8ca6-8513ace6d7a3.png)

## 概要
「ノミカイの準備を楽しく、便利に」

幹事さんと参加者双方に向けた、飲み会の準備を楽しく便利にサポートするサービスです。

## URL
https://nomi-joy.com

【かんたんログイン】ボタンからテストユーザーとしてログインできます。
幹事側へは、参加者側からログイン後「カンジの部屋」のロゴマークから入室できます。

## 制作の背景
前職で会社の飲み会の幹事をすることがありましたが、出欠や会費徴収の管理が大変でした。

特に、送別会のシーズンになると飲み会が月に何件も重なり、「どの飲み会をどこまで準備できているんだっけ？」「○○さんからこの前の会費をまだいただいてないけど目上の方だから何度もお願いしにくいな・・・」「○○さんが欠席したのはどの飲み会だったっけ？」などと混乱してしまうことがありました。

幹事をしてこのように大変な経験をした人は多いはず・・・そのような人たちが少しでも「便利にかつ楽しく」飲み会の準備をできたら、という思いからこのサービスを制作しました。同時に、参加者の方にとっても便利に利用できるサービスを目指しました。

## 主な利用シーン
飲み会の準備期間中〜集金完了まで

【幹事側】
* 会社の飲み会（中〜大人数規模）の幹事として、決定事項の記録、参加者への情報共有、会費の集金管理をしたいとき
* 幹事をする飲み会が多数あり、それぞれの進捗管理を行いたいとき

【参加者側】
* 飲み会の情報（場所、会費など）を確認したいとき
* 幹事に連絡をしたいとき（欠席や遅刻の連絡など）

## 機能一覧
* 通知機能 
  - フォローされた時、DMが届いた時、飲み会に招待された時、飲み会のリマインドが届いた時、幹事が支払い依頼ボタンを押した時、幹事に会費を領収された時に通知が来る
* メール機能 
  - 飲み会に招待された時、飲み会のリマインドが届いた時、幹事が支払い依頼ボタンを押した時、幹事に会費を領収された時、未読通知3件以上溜まったとき、参加する飲み会の前日にメール送信
* 定時処理 
  - 未読通知が3件以上溜まったユーザーに毎日午前８時にメール送信、飲み会の前日午前８時に参加者全員にメール・通知送信
* DM機能 
* ToDoリスト
* 検索機能 （ぐるなびAPIを使用し店舗検索、保存）
* マップ表示 （ぐるなびAPIにて取得した住所から表示）
* カレンダー表示(保存した飲み会情報を表示)
* マッチング（フォロー）機能 
* レスポンシブデザイン

![README-responsive](https://user-images.githubusercontent.com/60662524/88524761-bb736480-d034-11ea-94d1-dcfec3fc4266.png)

詳細は下記よりご確認ください。

https://docs.google.com/spreadsheets/d/1zn1J7OT1fU9TOgGupXXd03vXP6VqDejtVFZ6z9pqhcQ/edit#gid=1830135488

## 環境・使用技術
### フロントエンド
* Bootstrap 4.5.0
* SCSS (BEM)
* JavaScript、jQuery、Ajax

### バックエンド
* Ruby 2.5.7
* Rails 5.2.4.3

### 開発環境
* Vagrant 2.2.4
* Docker/Docker-compose
* MySQL2

### 本番環境
* AWS (EC2、RDS for MySQL、Route53、CloudWatch、S3、Lambda)
* MySQL2
* Nginx、 Puma
* CircleCIを用いてdocker-composeでコンテナを構築しCapistranoにより自動デプロイ

### インフラ構成図

![AWS構成図](https://user-images.githubusercontent.com/60662524/91147221-ed8aeb80-e6f2-11ea-85a6-084e361da2e0.png)

### テスト
* Rspec (単体／結合） 計200以上
* CircleCIを用いてDocker-composeでコンテナを構築し自動テスト

### その他使用技術
* 非同期通信 (フォロー・集金・メール送信など各種ボタン、検索、DM、ToDoリスト、画像アップロードの即時反映、タブ等)
* Action Mailer
* whenever （定時処理）
* 外部API(ぐるなび レストラン検索API、Google MapAPI、Geocoding API)
* Rubocop-airbnb
* HTTPS接続 (Certbot)
* チーム開発を意識したGitHubの活用 （マイルストーン、イシュー、プルリク、マージ）

## ER図
![スクリーンショット 2020-10-09 0 22 29](https://user-images.githubusercontent.com/60662524/95479314-951f5d00-09c5-11eb-8050-a99d50ffee10.png)

## About me
新卒で４年間損害保険会社に勤務しておりました。2020年４月からWebエンジニアを目指して勉強中です。

[Qiita](https://qiita.com/kyoooko)
