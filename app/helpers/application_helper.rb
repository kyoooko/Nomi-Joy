module ApplicationHelper
  def default_meta_tags
    {
      site: 'サイト名',
      title: "ノミジョイ！",
      description: "ノミジョイ！は、「ノミカイの準備を楽しく、便利に」するためのサービスです。参加者の方も幹事の方も簡単にご利用いただけます。",
      keywords: "飲み会,幹事,準備,管理,サービス", # キーワードを「,」で区切る
      icon: [
        { href: image_url('Nomi-Joy-square.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
      ],
      #   noindex: ! Rails.env.production?, # production環境以外はnoindex
      #   canonical: request.original_url,  # 優先されるurl
      #   charset: "UTF-8",
      # OGPの設定をしておくとfacebook, twitterなどの投稿を見た目よくしてくれる
      og: {
        title: :title, # 上のtitleと同じ値とするなら「:title」とする
        description: :description, # 上のdescriptionと同じ値とするなら「:description」とする
        type: "website",
        url: request.original_url,
        image: image_url("Nomi-Joy.png"),
        site_name: "ノミジョイ！",
        locale: "ja_JP",
      },
      twitter: {
        site: ENV['TWITTER_ACCOUNT'],
        card: 'summary_large_image',
        image: image_url("twitter-card.png"), # ツイッター専用にイメージを設定する場合
      },
      # ,
      #   fb: {
      #     app_id: '***************'    #ご自身のfacebookのapplication IDを設定
      #   }
    }
  end
end
