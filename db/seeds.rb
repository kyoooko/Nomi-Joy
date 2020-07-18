# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ◆ユーザー(10名)
User.create!(name:"能美ジョイ子", email: "test1@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy1", belongs: "オーシャンティック航空（株） 東自損3課 ", position: "副主任",image:File.open("./app/assets/images/ajisai.JPG", ?r),nearest_station:"吉祥寺", can_drink: true, favolite:"ワイン、もんじゃ焼き、スパイスカレー",unfavolite:"焼酎、胡麻豆腐", introduction:"新入社員の能美です。学生時代はバレーボール部に所属していました。白ワインが好きです。よろしくお願いいたします。")

User.create!(name:"能美ジョイ男", email: "test2@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy2", belongs: "パシフィックインターナショナル ", position: "代表取締役",image:"",nearest_station:"恵比寿", can_drink: true, favolite:"ビール、ワイン",unfavolite:"生魚", introduction:"麻布十番・恵比寿・代官山開拓中です！クラフトビール にハマっています！ぜひお声がけください！")

User.create!(name:"能美ジョー", email: "test3@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy3", belongs: "日本セラミック（株） ", position: "主任",image:File.open("./app/assets/images/Kanjino-Heya.png", ?r),nearest_station:"要町", can_drink: false, favolite:"刺身",unfavolite:"パクチー、納豆", introduction:"どうぞよろしくお願いします。")

User.create!(name:"西沢渉", email: "test4@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy4", belongs: "三光銀行 ", position: "主任",image:File.open("./app/assets/images/ajisai.JPG", ?r),nearest_station:"武蔵小杉", can_drink: true, favolite:"ビール、牡蠣、ラーメン",unfavolite:"なす", introduction:"平日も２０時以降参加できますのでたくさん飲みましょう！！")

User.create!(name:"秋山千紘", email: "test5@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy5", belongs: "青山商事（株） 経理２部１チーム", position: "副主事",image:File.open("./app/assets/images/ichigo.jpeg", ?r),nearest_station:"中野坂上", can_drink: true, favolite:"ワイン、スパイスカレー",unfavolite:"セロリ", introduction:"今は豊洲に勤務していますのでぜひお声がけください！")

User.create!(name:"林健太", email: "test6@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy6", belongs: "オーシャンティック航空（株） 東自損3課", position: "課長",image:File.open("./app/assets/images/usagi.jpeg", ?r),nearest_station:"目黒", can_drink: true, favolite:"お酒全般、ゆでたん",unfavolite:"特になし", introduction:"美味しいお店開拓中です！鶯谷の焼肉屋『鶯炎』がおすすめです！")

User.create!(name:"井上葉月", email: "test7@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy7", belongs: "オーシャンティック航空（株） 東自損3課", position: "主任",image:File.open("./app/assets/images/guruguru.jpeg", ?r),nearest_station:"五反田", can_drink: true, favolite:"日本酒、ハイボール、辛いもの",unfavolite:"ラム", introduction:"火鍋やタイ料理など辛いものにハマってます！今は市ヶ谷勤務です！")

User.create!(name:"梶谷真梨子", email: "test8@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy8", belongs: "オーシャンティック航空（株） 東自損3課", position: "副主任",image:File.open("./app/assets/images/candy.jpeg", ?r),nearest_station:"三軒茶屋", can_drink: false, favolite:"イタリアン",unfavolite:"パクチー", introduction:"最近ヨガにハマっている木村です。よろしくお願いします。")

User.create!(name:"加藤菜々子", email: "test9@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy9", belongs: "オーシャンティック航空（株） 東自損3課", position: "",image:File.open("./app/assets/images/pink_cake.jpeg", ?r),nearest_station:"清瀬", can_drink: true, favolite:"中華、韓国料理",unfavolite:"えび", introduction:"韓国料理にハマっているのでぜひ食べに行きたいです。よろしくお願いします。")

User.create!(name:"小野美紅", email: "test10@test.co.jp", password: "aaaaaaaa", nomi_joy_id:"nomijoy10", belongs: "オーシャンティック航空（株） 埼玉支社１チーム", position: "副主任",image:File.open("./app/assets/images/nomikai.png", ?r),nearest_station:"上板橋", can_drink: true, favolite:"もつ鍋、カレー",unfavolite:"トマト", introduction:"本年度より埼玉支社にて勤務しております。食べログ有料会員です(^ ^)")

# ◆マッチング
# user1がマッチング（＝メンバーになっている）済み(user2~6)
Relationship.create!(following_id:1,follower_id:2)
Relationship.create!(following_id:2,follower_id:1)
Relationship.create!(following_id:1,follower_id:3)
Relationship.create!(following_id:3,follower_id:1)
Relationship.create!(following_id:1,follower_id:4)
Relationship.create!(following_id:4,follower_id:1)
Relationship.create!(following_id:1,follower_id:5)
Relationship.create!(following_id:5,follower_id:1)
Relationship.create!(following_id:1,follower_id:6)
Relationship.create!(following_id:6,follower_id:1)
# user1が申請中(user7)
Relationship.create!(following_id:1,follower_id:7)
# user1へ申請依頼あり(user8,9)
Relationship.create!(following_id:8,follower_id:1)
Relationship.create!(following_id:9,follower_id:1)
# user1とuser10はお互いに申請していない

# ◆Room
Room.create!

# ◆Entry
Entry.create!(user_id: 1, room_id: 1)
Entry.create!(user_id: 5, room_id: 1)

# ◆DM
DirectMessage.create!(user_id:5, room_id:1, message: "お疲れ様です。7/30の歓迎会ですが、子供の関係でいけなくなってしました・・・残念ですが欠席でお願いします。" )
DirectMessage.create!(user_id:1, room_id:1, message: "承知致しました。ご連絡ありがとうございます。" )

#◆ノミカイ１（カンジ：user1、参加メンバー：user1~4、お店：restaurant1)
Restaurant.create!(user_id: 1,name:"上海庭 九段南店",address:"〒102-0074  東京都千代田区九段南3-2-12 上海庭ビル1～3F ＪＲ中央線 市ヶ谷駅 徒歩8分",access:"東京メトロ東西線九段下駅徒歩５分",url:"https://r.gnavi.co.jp/e263700/",shop_image:"shanhaitei.png",tel:"050-3490-6986",opentime:"月～土 ランチ 11:00～15:00 ディナー 17:00～22:00",holiday:"年中無休
年末年始のみお休みを頂きます。")
Event.create!(restaurant_id:1,user_id:1,name:"2020年3課暑気払い",date:"2020-07-22 00:00:00",begin_time:"2020-07-22 18:00:00",end_time:"2020-07-22 21:00:00",memo:"締めは林さんにお願いする。お店に1名欠席の連絡",progress_status:0)
EventUser.create!(user_id:1,event_id:1,fee:4000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:2,event_id:1,fee:3500,fee_status:false,deleted_at:"")
EventUser.create!(user_id:3,event_id:1,fee:4000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:4,event_id:1,fee:4500,fee_status:true,deleted_at:"")


# ◆ノミカイ２（カンジ：user2、参加メンバー：user1,2,5,6、お店：restaurant2)
Restaurant.create!(user_id: 2,name:"市ヶ谷魚金",address:"東京都千代田区五番町6-5 クレスト五番町 1・2F",access:"JR市ヶ谷駅から徒歩3分",url:"https://tabelog.com/tokyo/A1309/A130904/13217305/",shop_image:"uokin.png",tel:"050-5596-0401",opentime:"［日曜～土曜]11:30～23:00",holiday:"年末年始")
Event.create!(restaurant_id:2,user_id:2,name:"野澤さん送別会",date:"2020-07-28 00:00:00",begin_time:"2020-07-28 18:30:00",end_time:"2020-07-28 21:00:00",memo:"吉田さんは19時から参加、花束と色紙用意する",progress_status:1)
EventUser.create!(user_id:1,event_id:2,fee:3500,fee_status:false,deleted_at:"")
EventUser.create!(user_id:2,event_id:2,fee:3500,fee_status:false,deleted_at:"")
EventUser.create!(user_id:5,event_id:2,fee:4000,fee_status:true,deleted_at:"")
EventUser.create!(user_id:6,event_id:2,fee:4500,fee_status:true,deleted_at:"")

# ◆ノミカイ３（カンジ：user1、参加メンバー：user1~6、お店：restaurant3)
Restaurant.create!(user_id: 1,name:"KICHIRI 新宿",address:"〒160-0022  東京都新宿区新宿3-36-10 ミラザ新宿4F",access:"ＪＲ 新宿駅 中央東口 徒歩1分",url:"https://r.gnavi.co.jp/b441509/",shop_image:"kichiri.png",tel:"050-3464-0249",opentime:"月～金・日・祝日 17:00～23:00（L.O.22:00、ドリンクL.O.22:00）",holiday:"無")
Event.create!(restaurant_id:3,user_id:1,name:"3課新人歓迎会",date:"2020-07-30 00:00:00",begin_time:"2020-07-30 18:30:00",end_time:"2020-07-30 21:00:00",memo:"新人さんに着任挨拶を依頼する、最初の挨拶→林課長、中締め→村瀬課長代理",progress_status:2)
EventUser.create!(user_id:1,event_id:3,fee:3000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:2,event_id:3,fee:3500,fee_status:false,deleted_at:"")
EventUser.create!(user_id:3,event_id:3,fee:4000,fee_status:true,deleted_at:"")
EventUser.create!(user_id:4,event_id:3,fee:4500,fee_status:true,deleted_at:"")
EventUser.create!(user_id:5,event_id:3,fee:5000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:6,event_id:3,fee:5500,fee_status:true,deleted_at:"")

# ◆ノミカイ４（カンジ：user1、参加メンバー：user1~3、お店：restaurant4)
# Restaurant.create!(user_id: 1,name:"金沢乃家 九段下店",address:"千代田区九段下北1-2-3 フナトビル",access:"地下鉄東西線 九段下駅 徒歩1分",latitude: "",longitude: "",url:"https://github.com/twbs/bootstrap-rubygem",shop_image:"",tel:"03-0000-0000",opentime:"17~24時",holiday:"年末年始")
# Event.create!(restaurant_id:4,user_id:1,name:"同期会",date:"2020-07-16 00:00:00",begin_time:"2020-07-16 18:30:00",end_time:"2020-07-16 21:30:00",memo:"山田さんは出欠確認中",progress_status:1)
# EventUser.create!(user_id:1,event_id:3,fee:3000,fee_status:false,deleted_at:"")
# EventUser.create!(user_id:2,event_id:3,fee:3000,fee_status:true,deleted_at:"")
# EventUser.create!(user_id:3,event_id:3,fee:3000,fee_status:false,deleted_at:"")

# ◆通知
Notification.create!(visitor_id:8, visited_id:1, action: "follow")
Notification.create!(visitor_id:5, visited_id:1, action: "dm", direct_message_id: 1)
Notification.create!(visitor_id:2, visited_id:1, action: "require_fee",event_id: 2)
Notification.create!(visitor_id:1, visited_id:5, action: "dm", direct_message_id: 2)

