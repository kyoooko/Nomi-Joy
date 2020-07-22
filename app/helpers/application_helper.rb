module ApplicationHelper

  def default_meta_tags
    {
      site: 'サイト名',
      title:       "ノミジョイ！",
      description: "ノミジョイ！は、「飲み会の準備を楽しく、便利に」するためのサービスです。登録をすることで、簡単に参加者の方も幹事の方もご利用いただけます。",
      keywords:    "飲み会,幹事,準備,管理,サービス", #キーワードを「,」で区切る
      icon: [
        { href: image_url('Nomi-Joy.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
      ],
    #   noindex: ! Rails.env.production?, # production環境以外はnoindex
	  # canonical: request.original_url,  # 優先されるurl
    #   charset: "UTF-8",
      # OGPの設定をしておくとfacebook, twitterなどの投稿を見た目よくしてくれる
      og: {
        title: :title,                #上のtitleと同じ値とするなら「:title」とする
        description: :description, #上のdescriptionと同じ値とするなら「:description」とする
        type: "website",
        url: request.original_url,
        image: image_url("Nomi-Joy.png"),
        site_name: "ノミジョイ！",
        locale: "ja_JP"
      }
    #   ,
    #   twitter: {
    #     site: '@ツイッターのアカウント名',
    #     card: 'summary',
    #     image: image_url("sample_twitter.png") # ツイッター専用にイメージを設定する場合
	  # },
    #   fb: {
    #     app_id: '***************'    #ご自身のfacebookのapplication IDを設定
    #   }
    }
  end
end
