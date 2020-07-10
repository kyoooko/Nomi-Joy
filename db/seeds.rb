# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
