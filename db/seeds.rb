# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ◆ユーザー(10名)
User.create!(name:"能美ジョイ子", email: "test.kyoooko@gmail.com", password: "hanadan628", nomi_joy_id:"nomijoy1", belongs: "オーシャンティック航空（株） 東自損3課 ", position: "副主任",image:File.open("./app/assets/images/ajisai.JPG", ?r),nearest_station:"吉祥寺", can_drink: true, favolite:"ワイン、もんじゃ焼き、スパイスカレー",unfavolite:"焼酎、胡麻豆腐", introduction:"新入社員の能美です。学生時代はバレーボール部に所属していました。白ワインが好きです。よろしくお願いいたします。")

User.create!(name:"能美ジョイ男", email: "liliuokalani_618@yahoo.co.jp", password: "hanadan628", nomi_joy_id:"nomijoy2", belongs: "パシフィックインターナショナル ", position: "代表取締役",image:"",nearest_station:"恵比寿", can_drink: true, favolite:"ビール、ワイン",unfavolite:"生魚", introduction:"麻布十番・恵比寿・代官山開拓中です！クラフトビール にハマっています！ぜひお声がけください！")

User.create!(name:"能美ジョー", email: "12ec153m@al.rikkyo.ac.jp", password: "hanadan628", nomi_joy_id:"nomijoy3", belongs: "日本セラミック（株） ", position: "主任",image:File.open("./app/assets/images/Kanjino-Heya.png", ?r),nearest_station:"要町", can_drink: false, favolite:"刺身",unfavolite:"パクチー、納豆", introduction:"どうぞよろしくお願いします。")

User.create!(name:"西沢渉", email: "test@test.co.jp", password: "aaaaaa", nomi_joy_id:"nomijoy4", belongs: "三光銀行 ", position: "主任",image:File.open("./app/assets/images/ajisai.JPG", ?r),nearest_station:"武蔵小杉", can_drink: true, favolite:"ビール、牡蠣、ラーメン",unfavolite:"なす", introduction:"平日も２０時以降参加できますのでたくさん飲みましょう！！")

User.create!(name:"秋山千紘", email: "test5@test.co.jp", password: "aaaaaa", nomi_joy_id:"nomijoy5", belongs: "青山商事（株） 経理２部１チーム", position: "副主事",image:File.open("./app/assets/images/ichigo.jpeg", ?r),nearest_station:"中野坂上", can_drink: true, favolite:"ワイン、スパイスカレー",unfavolite:"セロリ", introduction:"今は豊洲に勤務していますのでぜひお声がけください！")

User.create!(name:"林健太", email: "test6@test.co.jp", password: "aaaaaa", nomi_joy_id:"nomijoy6", belongs: "オーシャンティック航空（株） 東自損3課", position: "課長",image:File.open("./app/assets/images/usagi.jpeg", ?r),nearest_station:"目黒", can_drink: true, favolite:"お酒全般、ゆでたん",unfavolite:"特になし", introduction:"美味しいお店開拓中です！鶯谷の焼肉屋『鶯炎』がおすすめです！")

User.create!(name:"井上葉月", email: "test7@test.co.jp", password: "aaaaaa", nomi_joy_id:"nomijoy7", belongs: "オーシャンティック航空（株） 東自損3課", position: "主任",image:File.open("./app/assets/images/guruguru.jpeg", ?r),nearest_station:"五反田", can_drink: true, favolite:"日本酒、ハイボール、辛いもの",unfavolite:"ラム", introduction:"火鍋やタイ料理など辛いものにハマってます！今は市ヶ谷勤務です！")

User.create!(name:"木村真梨子", email: "test8@test.co.jp", password: "aaaaaa", nomi_joy_id:"nomijoy8", belongs: "オーシャンティック航空（株） 東自損3課", position: "副主任",image:File.open("./app/assets/images/candy.jpeg", ?r),nearest_station:"三軒茶屋", can_drink: false, favolite:"イタリアン",unfavolite:"パクチー", introduction:"最近ヨガにハマっている木村です。よろしくお願いします。")

User.create!(name:"加藤菜々子", email: "test9@test.co.jp", password: "aaaaaa", nomi_joy_id:"nomijoy9", belongs: "オーシャンティック航空（株） 東自損3課", position: "",image:File.open("./app/assets/images/pink_cake.jpeg", ?r),nearest_station:"清瀬", can_drink: true, favolite:"中華、韓国料理",unfavolite:"えび", introduction:"韓国料理にハマっているのでぜひ食べに行きたいです。よろしくお願いします。")

User.create!(name:"小野美紅", email: "test10@test.co.jp", password: "aaaaaa", nomi_joy_id:"nomijoy10", belongs: "オーシャンティック航空（株） 埼玉支社１チーム", position: "副主任",image:File.open("./app/assets/images/nomikai.png", ?r),nearest_station:"上板橋", can_drink: true, favolite:"もつ鍋、カレー",unfavolite:"トマト", introduction:"本年度より埼玉支社にて勤務しております。食べログ有料会員です(^ ^)")

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


#◆ノミカイ１（カンジ：user1、参加メンバー：user1~4、お店：restaurant1)
Restaurant.create!(user_id: 1,name:"上海庭 九段下駅前店",address:"千代田区三番町0−0−0",access:"東京メトロ東西線九段下駅徒歩５分",latitude: "",longitude: "",url:"https://github.com/twbs/bootstrap-rubygem",shop_image:"",tel:"03-0000-0000",opentime:"11~24時",holiday:"水曜日")
Event.create!(restaurant_id:1,user_id:1,name:"2020年3課暑気払い",date:"2020-07-22",start_time:"2020-07-22 18:00:00",end_time:"2020-07-22 21:00:00",memo:"締めは林さんにお願いする。お店に1名欠席の連絡",progress_status:0,fee_status:false)
EventUser.create!(user_id:1,event_id:1,fee:3000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:2,event_id:1,fee:3500,fee_status:false,deleted_at:"")
EventUser.create!(user_id:3,event_id:1,fee:4000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:4,event_id:1,fee:4500,fee_status:true,deleted_at:"")


# ◆ノミカイ２（カンジ：user2、参加メンバー：user1,2,5,6、お店：restaurant2)
Restaurant.create!(user_id: 2,name:"魚金 市ヶ谷店",address:"千代田区三番町0−0−0",access:"東京メトロ東西線市ヶ谷駅徒歩1分",latitude: "",longitude: "",url:"https://github.com/twbs/bootstrap-rubygem",shop_image:"",tel:"03-0000-0000",opentime:"17~25時",holiday:"火曜日")
Event.create!(restaurant_id:2,user_id:2,name:"野澤さん送別会",date:"2020-07-28",start_time:"2020-07-28 18:30:00",end_time:"2020-07-28 21:00:00",memo:"吉田さんは19時から参加",progress_status:1,fee_status:false)
EventUser.create!(user_id:1,event_id:2,fee:3000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:2,event_id:2,fee:3500,fee_status:false,deleted_at:"")
EventUser.create!(user_id:5,event_id:2,fee:4000,fee_status:true,deleted_at:"")
EventUser.create!(user_id:6,event_id:2,fee:4500,fee_status:true,deleted_at:"")

# ◆ノミカイ３（カンジ：user1、参加メンバー：user1~6、お店：restaurant3)
Restaurant.create!(user_id: 1,name:"KITIRI 新宿東口店",address:"新宿区百人町0−0−0",access:"JR新宿駅徒歩2分",latitude: "",longitude: "",url:"https://github.com/twbs/bootstrap-rubygem",shop_image:"",tel:"03-0000-0000",opentime:"11~26時",holiday:"なし")
Event.create!(restaurant_id:3,user_id:1,name:"3課新人歓迎会",date:"2020-07-30",start_time:"2020-07-13 19:00:00",end_time:"2020-07-13 21:00:00",memo:"新人さんに挨拶を依頼する。",progress_status:2,fee_status:false)
EventUser.create!(user_id:1,event_id:3,fee:3000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:2,event_id:3,fee:3500,fee_status:false,deleted_at:"")
EventUser.create!(user_id:3,event_id:3,fee:4000,fee_status:true,deleted_at:"")
EventUser.create!(user_id:4,event_id:3,fee:4500,fee_status:true,deleted_at:"")
EventUser.create!(user_id:5,event_id:3,fee:5000,fee_status:false,deleted_at:"")
EventUser.create!(user_id:6,event_id:3,fee:5500,fee_status:true,deleted_at:"")
