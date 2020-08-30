require 'rails_helper'

RSpec.describe "Admin::Events", type: :request do
  # ログインしているユーザー／カンジ
  let!(:user) { create(:user) }
  # ログインしていないユーザー
  let(:user_2) { create(:user) }
  let(:user_3) { create(:user) }
  let!(:restaurant) { create(:restaurant, user_id: user.id) }
  let!(:event) { create(:event, restaurant_id: restaurant.id, user_id: user.id) }
  let!(:event_user) { create(:event_user, user_id: user.id, event_id: event.id) }
  let!(:event_user_2) { create(:event_user, user_id: user_2.id, event_id: event.id) }

  describe "トップページを表示(GET #index)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_events_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        get admin_events_path
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "ノミカイ詳細ページを表示(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_event_path event.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        get admin_event_path event.id
        expect(response).to have_http_status "200"
      end
    end
  end

  # show(タブ１)
  describe "ノミカイ編集ページを表示(GET #edit)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get edit_admin_event_path event.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        it "リクエストが成功すること" do
          get edit_admin_event_path event.id
          expect(response).to have_http_status "200"
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          get edit_admin_event_path event.id
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "ノミカイの編集を更新(PUT #update)" do
    let(:update_params) { { name: "変更後ノミカイ名" } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        put admin_event_path event.id, event: update_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        it "リクエストが成功すること" do
          put admin_event_path event.id, event: update_params
          expect(response.status).to eq 302
        end
        it "更新が成功すること" do
          put admin_event_path event.id, event: update_params
          expect(event.reload.name).to eq "変更後ノミカイ名"
        end
        it "ノミカイ詳細ページへリダイレクトすること" do
          put admin_event_path event.id, event: update_params
          expect(response).to redirect_to admin_event_path event.id
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          put admin_event_path event.id, event: update_params
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "ノミカイの編集を削除(DELETE #destroy)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        delete admin_event_path event.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        it "リクエストが成功すること" do
          delete admin_event_path event.id
          expect(response.status).to eq 302
        end
        it "削除が成功すること" do
          delete admin_event_path event.id
          expect(Event.find_by(user_id: user.id)).to be_falsey
        end
        it "ノミカイ一覧ページへリダイレクトすること" do
          delete admin_event_path event.id
          expect(response).to redirect_to admin_events_path
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          delete admin_event_path event.id
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "ノミカイのステータスを更新(PUT #progress_status_update)" do
    let (:progress_status_update_params) { { event: { progress_status: 1 } } }

    context "未ログインの場合" do
      it "Unauthorizedエラーが出ること" do
        # 401: Unauthorized
        patch admin_events_progress_status_path(event.id), params: progress_status_update_params, xhr: true
        expect(response.status).to eq 401
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        it "非同期によるステータス更新のリクエストが成功すること" do
          # 非同期のため302でなく200
          patch admin_events_progress_status_path(event.id), params: progress_status_update_params, xhr: true
          expect(response.status).to eq 200
        end
        it "非同期によるステータス更新が成功すること" do
          patch admin_events_progress_status_path(event.id), params: progress_status_update_params, xhr: true
          expect(event.reload.progress_status).to eq 1
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          patch admin_events_progress_status_path(event.id), params: progress_status_update_params, xhr: true
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  # show(タブ２）
  describe "ノミカイ参加者追加ページを表示(GET #add_event_user)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_add_event_user_path(event.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        it "リクエストが成功すること" do
          get admin_add_event_user_path(event.id)
          expect(response).to have_http_status "200"
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          get admin_add_event_user_path(event.id)
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "参加メンバーの追加後会費設定編集ページを表示(POST #add_event_user_fee)" do
    let (:event_user_ids_params) { { event_user: { ids: ["", user.id, user_2.id] } } }
    let (:nil_event_user_ids_params) { { event_user: { ids: [""] } } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        context "追加メンバーを選択したら" do
          it "リクエストが成功し、会費設定編集ページが表示されること" do
            # このpostはページの表示兼paramsの送信なので302でなく200
            post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
            expect(response).to have_http_status "200"
          end
        end

        context "追加メンバーを選択しなかったら" do
          it "リクエストが失敗すること" do
            post admin_add_event_user_fee_path(event.id), params: nil_event_user_ids_params
            expect(response).to have_http_status "302"
          end

          it "ノミカイ参加者追加ページにリダイレクトすること" do
            post admin_add_event_user_fee_path(event.id), params: nil_event_user_ids_params
            expect(response).to redirect_to admin_add_event_user_path(event.id)
          end
        end

        context "戻るボタンを押したら" do
          it "リクエストが成功すること" do
            post admin_add_event_user_fee_path(event.id), params: { event_user: { ids: [""] }, back: "戻る" }
            expect(response).to have_http_status "302"
          end

          it "詳細ページにリダイレクトされること" do
            post admin_add_event_user_fee_path(event.id), params: { event_user: { ids: [""] }, back: "戻る" }
            expect(response).to redirect_to admin_event_path event.id, room: 2
          end
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "参加メンバーの追加後会費設定編集ページを表示(POST #add_event_user_fee)" do
    let (:event_user_ids_params) { { event_user: { ids: ["", user.id, user_2.id] } } }
    let (:fees_params) { { fees: ["3000", "4000"] } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
        post admin_add_event_user_create_path(event.id), params: fees_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        context "追加ボタンを押したら" do
          it "リクエストが成功すること" do
            post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
            post admin_add_event_user_create_path(event.id), params: fees_params
            expect(response).to have_http_status "302"
          end

          it "ノミカイ詳細ページにリダイレクトすること" do
            post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
            post admin_add_event_user_create_path(event.id), params: fees_params
            expect(response).to redirect_to admin_event_path(event.id, room: 2)
          end
        end

        context "戻るボタンを押したら" do
          it "リクエストが成功すること" do
            # リダイレクトではなくrenderなので302でなく200
            post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
            post admin_add_event_user_create_path(event.id), params: { event: fees_params, back: "戻る" }
            expect(response).to have_http_status "200"
          end
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          post admin_add_event_user_fee_path(event.id), params: event_user_ids_params
          post admin_add_event_user_create_path(event.id), params: fees_params
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  # show(タブ４）
  describe "お店の変更(GET #change_restaurant)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_change_restaurant_path(event.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      context "カンジの場合" do
        before do
          sign_in user
        end

        context "変更ページを表示" do
          it "リクエストが成功すること" do
            get admin_change_restaurant_path(event.id)
            expect(response).to have_http_status "200"
          end
        end

        context "更新ボタンを押したら" do
          let (:restaurant_params) { "{\"@attributes\"=>{\"order\"=>0}, \"id\"=>\"a127617\", \"update_date\"=>\"2020-08-26T13:45:28+09:00\", \"name\"=>\"くいもの屋わん 大宮南銀通り店\", \"name_kana\"=>\"クイモノヤワン オオミヤナンギンドオリテン\", \"url\"=>\"https://r.gnavi.co.jp/a127617/?ak=Z2rHoeARvgskgkLLcLGmAms4orYpvb6osrE291%2FehB4%3D\", \"image_url\"=>{\"shop_image1\"=>\"https://rimage.gnst.jp/rest/img/aax8xkgd0000/t_01r6.jpg\"}, \"address\"=>\"〒330-0845 埼玉県さいたま市大宮区仲町1-24 オリンピアビル2F\", \"tel\"=>\"050-3464-7669\", \"tel_sub\"=>\"048-631-1222\", \"fax\"=>\"048-631-1222\", \"opentime\"=>\" 16:00～翌03:00\", \"holiday\"=>\"年中無休\", \"access\"=>{\"line\"=>\"ＪＲ\", \"station\"=>\"大宮駅\", \"station_exit\"=>\"東口\", \"walk\"=>\"2\", \"note\"=>\"\"}}" }

          context "お店を選択したら" do
            it "リクエストが成功すること" do
              get admin_change_restaurant_path(event.id), params: { restaurant: restaurant_params, change: "変更" }
              expect(response).to have_http_status "302"
            end

            it "ノミカイ詳細ページにリダイレクトすること" do
              get admin_change_restaurant_path(event.id), params: { restaurant: restaurant_params, change: "変更" }
              expect(response).to redirect_to admin_event_path(event.id, room: 4)
            end
          end

          context "お店を選択しなかったら" do
            it "リクエストが失敗すること" do
              get admin_change_restaurant_path(event.id), params: { change: "変更" }
              expect(response).to have_http_status "200"
            end

            it "詳細ページにリダイレクトされないこと" do
              get admin_change_restaurant_path(event.id), params: { change: "変更" }
              expect(response).not_to redirect_to admin_event_path(event.id, room: 4)
            end
          end
        end

        context "戻るボタンを押したら" do
          it "リクエストが成功すること" do
            get admin_change_restaurant_path(event.id), params: { back: "戻る" }
            expect(response).to have_http_status "302"
          end

          it "詳細ページにリダイレクトされること" do
            get admin_change_restaurant_path(event.id), params: { back: "戻る" }
            expect(response).to redirect_to admin_event_path event.id, room: 4
          end
        end
      end

      context "カンジ以外の場合" do
        before do
          sign_in user_2
        end

        it "ログイン前トップページへリダイレクトすること" do
          get admin_change_restaurant_path(event.id)
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "ノミカイ新規作成(1)：基本情報入力ページ表示(GET #step1)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_step1_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        get admin_step1_path
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "ノミカイ新規作成(2)(POST #step2)" do
    let (:event_params) { { name: "野澤さん送別会", date: "2020-07-30 00:00:00", begin_time: "2020-07-30 18:00:00", finish_time: "2020-07-30 20:00:00", memo: "花束用意する" } }
    let (:restaurant_params) { "{\"@attributes\"=>{\"order\"=>0}, \"id\"=>\"a127617\", \"update_date\"=>\"2020-08-26T13:45:28+09:00\", \"name\"=>\"くいもの屋わん 大宮南銀通り店\", \"name_kana\"=>\"クイモノヤワン オオミヤナンギンドオリテン\", \"url\"=>\"https://r.gnavi.co.jp/a127617/?ak=Z2rHoeARvgskgkLLcLGmAms4orYpvb6osrE291%2FehB4%3D\", \"image_url\"=>{\"shop_image1\"=>\"https://rimage.gnst.jp/rest/img/aax8xkgd0000/t_01r6.jpg\"}, \"address\"=>\"〒330-0845 埼玉県さいたま市大宮区仲町1-24 オリンピアビル2F\", \"tel\"=>\"050-3464-7669\", \"tel_sub\"=>\"048-631-1222\", \"fax\"=>\"048-631-1222\", \"opentime\"=>\" 16:00～翌03:00\", \"holiday\"=>\"年中無休\", \"access\"=>{\"line\"=>\"ＪＲ\", \"station\"=>\"大宮駅\", \"station_exit\"=>\"東口\", \"walk\"=>\"2\", \"note\"=>\"\"}}" }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        post admin_step2_path, params: { event: event_params }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      context "お店検索ページ表示" do
        it "リクエストが成功すること" do
          # このpostはページの表示兼paramsの送信なので302でなく200
          post admin_step2_path, params: { event: event_params }
          expect(response).to have_http_status "200"
        end
      end

      context "お店を選択したら" do
        it "リクエストが成功すること" do
          post admin_step2_path, params: { event: event_params, restaurant: restaurant_params, next: "次へ" }
          expect(response).to have_http_status "302"
        end

        it "Step3ページにリダイレクトすること" do
          post admin_step2_path, params: { event: event_params, restaurant: restaurant_params, next: "次へ" }
          expect(response).to redirect_to admin_step3_path(event: event_params)
        end
      end

      context "お店を選択しなかったら" do
        it "リクエストが失敗すること" do
          post admin_step2_path, params: { event: event_params, next: "次へ" }
          expect(response).to have_http_status "200"
        end

        it "Step3ページにリダイレクトされないこと" do
          post admin_step2_path, params: { event: event_params, next: "次へ" }
          expect(response).not_to redirect_to admin_step3_path(event: event_params)
        end
      end

      context "戻るボタンを押したら" do
        it "リクエストが成功すること" do
          # リダイレクトではなくrenderなので302でなく200
          post admin_step2_path, params: { event: event_params, back: "戻る" }
          expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "ノミカイ新規作成(3)(GET #step3)" do
    let (:event_params) { { name: "野澤さん送別会", date: "2020-07-30 00:00:00", begin_time: "2020-07-30 18:00:00", finish_time: "2020-07-30 20:00:00", memo: "花束用意する" } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_step3_path(event: event_params)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      context "メンバー選択ページの表示" do
        it "リクエストが成功すること" do
          get admin_step3_path(event: event_params)
          expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "ノミカイ新規作成(4)(POST #step4)" do
    let (:event_params) { { name: "野澤さん送別会", date: "2020-07-30 00:00:00", begin_time: "2020-07-30 18:00:00", finish_time: "2020-07-30 20:00:00", memo: "花束用意する" } }
    let (:event_user_ids_params) { { ids: ["", user.id, user_2.id] } }
    let (:nil_event_user_ids_params) { { ids: [""] } }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        post admin_step4_path, params: { event_user: event_user_ids_params, event: event_params }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      context "追加メンバーを選択したら" do
        it "リクエストが成功し、会費設定編集ページが表示されること" do
          # このpostはページの表示兼paramsの送信なので302でなく200
          post admin_step4_path, params: { event_user: event_user_ids_params, event: event_params }
          expect(response).to have_http_status "200"
        end
      end

      context "追加メンバーを選択しなかったら" do
        it "リクエストが失敗すること" do
          # renderのため302でなく200
          post admin_step4_path, params: { event_user: nil_event_user_ids_params, event: event_params }
          expect(response).to have_http_status "200"
        end
      end

      context "戻るボタンを押したら" do
        it "リクエストが成功すること" do
          # リダイレクトではなくrenderなので302でなく200
          post admin_step4_path, params: { event: event_params, event_user: nil_event_user_ids_params, back: "戻る" }
          expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "ノミカイ新規作成(5)(POST #confirm)" do
    let (:event_params) { { name: "野澤さん送別会", date: "2020-07-30 00:00:00", begin_time: "2020-07-30 18:00:00", finish_time: "2020-07-30 20:00:00", memo: "花束用意する" } }
    let (:fees_params) {  ["3000", "4000"] }
    let (:admin_fee_params) { "5000" }
    let (:event_user_ids_params) { { ids: ["", user_2.id, user_3.id] } }
    let (:restaurant_params) { "{\"@attributes\"=>{\"order\"=>0}, \"id\"=>\"a127617\", \"update_date\"=>\"2020-08-26T13:45:28+09:00\", \"name\"=>\"くいもの屋わん 大宮南銀通り店\", \"name_kana\"=>\"クイモノヤワン オオミヤナンギンドオリテン\", \"url\"=>\"https://r.gnavi.co.jp/a127617/?ak=Z2rHoeARvgskgkLLcLGmAms4orYpvb6osrE291%2FehB4%3D\", \"image_url\"=>{\"shop_image1\"=>\"https://rimage.gnst.jp/rest/img/aax8xkgd0000/t_01r6.jpg\"}, \"address\"=>\"〒330-0845 埼玉県さいたま市大宮区仲町1-24 オリンピアビル2F\", \"tel\"=>\"050-3464-7669\", \"tel_sub\"=>\"048-631-1222\", \"fax\"=>\"048-631-1222\", \"opentime\"=>\" 16:00～翌03:00\", \"holiday\"=>\"年中無休\", \"access\"=>{\"line\"=>\"ＪＲ\", \"station\"=>\"大宮駅\", \"station_exit\"=>\"東口\", \"walk\"=>\"2\", \"note\"=>\"\"}}" }

    context "未ログインの場合" do
      before do
        post admin_step2_path, params: { event: event_params, restaurant: restaurant_params, next: "次へ" }
        get admin_step3_path(event: event_params)
        post admin_step4_path, params: { event_user: event_user_ids_params, event: event_params }
      end

      it "ログインページへリダイレクトすること" do
        post admin_confirm_path, params: { event: event_params, fees: fees_params, admin_fee: admin_fee_params }
        expect(response).to redirect_to    new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
      end

      context "次へボタンを押したら" do
        before do
          post admin_step2_path, params: { event: event_params, restaurant: restaurant_params, next: "次へ" }
          get admin_step3_path(event: event_params)
          post admin_step4_path, params: { event_user: event_user_ids_params, event: event_params }
        end

        it "リクエストが成功し、確認ページが表示されること" do
          # このpostはページの表示兼paramsの送信なので302でなく200
          post admin_confirm_path, params: { event: event_params, fees: fees_params, admin_fee: admin_fee_params }
          expect(response).to have_http_status "200"
        end
      end

      context "戻るボタンを押したら" do
        it "リクエストが成功すること" do
          # リダイレクトではなくrenderなので302でなく200
          post admin_confirm_path, params: { event: event_params, fees: fees_params, admin_fee: admin_fee_params, back: "戻る" }
          expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "ノミカイ新規作成(6)(POST #create)" do
    let (:event_params) { { name: "野澤さん送別会", date: "2020-07-30 00:00:00", begin_time: "2020-07-30 18:00:00", finish_time: "2020-07-30 20:00:00", memo: "花束用意する" } }
    let (:fees_params) {  ["3000", "4000"] }
    let (:admin_fee_params) { "5000" }
    let (:event_user_ids_params) { { ids: ["", user_2.id, user_3.id] } }
    let (:restaurant_params) { "{\"@attributes\"=>{\"order\"=>0}, \"id\"=>\"a127617\", \"update_date\"=>\"2020-08-26T13:45:28+09:00\", \"name\"=>\"くいもの屋わん 大宮南銀通り店\", \"name_kana\"=>\"クイモノヤワン オオミヤナンギンドオリテン\", \"url\"=>\"https://r.gnavi.co.jp/a127617/?ak=Z2rHoeARvgskgkLLcLGmAms4orYpvb6osrE291%2FehB4%3D\", \"image_url\"=>{\"shop_image1\"=>\"https://rimage.gnst.jp/rest/img/aax8xkgd0000/t_01r6.jpg\"}, \"address\"=>\"〒330-0845 埼玉県さいたま市大宮区仲町1-24 オリンピアビル2F\", \"tel\"=>\"050-3464-7669\", \"tel_sub\"=>\"048-631-1222\", \"fax\"=>\"048-631-1222\", \"opentime\"=>\" 16:00～翌03:00\", \"holiday\"=>\"年中無休\", \"access\"=>{\"line\"=>\"ＪＲ\", \"station\"=>\"大宮駅\", \"station_exit\"=>\"東口\", \"walk\"=>\"2\", \"note\"=>\"\"}}" }

    context "未ログインの場合" do
      before do
        post admin_step2_path, params: { event: event_params, restaurant: restaurant_params, next: "次へ" }
        get admin_step3_path(event: event_params)
        post admin_step4_path, params: { event_user: event_user_ids_params, event: event_params }
        post admin_confirm_path, params: { event: event_params, fees: fees_params, admin_fee: admin_fee_params }
      end

      it "ログインページへリダイレクトすること" do
        post admin_events_path, params: { event: event_params }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
        post admin_step2_path, params: { event: event_params, restaurant: restaurant_params, next: "次へ" }
        get admin_step3_path(event: event_params)
        post admin_step4_path, params: { event_user: event_user_ids_params, event: event_params }
        post admin_confirm_path, params: { event: event_params, fees: fees_params, admin_fee: admin_fee_params }
      end

      context "つくるボタンを押したら" do
        it "リクエストが成功すること" do
          post admin_events_path, params: { event: event_params }
          expect(response).to have_http_status "302"
        end

        it "詳細ページにリダイレクトされること" do
          post admin_events_path, params: { event: event_params }
          new_event = Event.last
          expect(response).to redirect_to admin_event_path(new_event.id)
        end

        it "詳細ページにリダイレクトされること" do
          post admin_events_path, params: { event: event_params }
          expect(Event.find_by(name: "野澤さん送別会", memo: "花束用意する", user_id: user.id)).to be_truthy
        end

        # ノミカイユーザーはカンジ含め３人
        it "ノミカイユーザーが作成されること" do
          post admin_events_path, params: { event: event_params }
          new_event = Event.last
          expect(EventUser.where(event_id: new_event.id).count == 3).to be_truthy
        end
      end

      context "つくる（メールで通知する）ボタンを押したら" do
        it "リクエストが成功すること" do
          post admin_events_path, params: { event: event_params }
          expect(response).to have_http_status "302"
        end

        it "詳細ページにリダイレクトされること" do
          post admin_events_path, params: { event: event_params }
          new_event = Event.last
          expect(response).to redirect_to admin_event_path(new_event.id)
        end

        it "詳細ページにリダイレクトされること" do
          post admin_events_path, params: { event: event_params }
          expect(Event.find_by(name: "野澤さん送別会", memo: "花束用意する", user_id: user.id)).to be_truthy
        end

        # ノミカイユーザーはカンジ含め３人
        it "ノミカイユーザーが作成されること" do
          post admin_events_path, params: { event: event_params }
          new_event = Event.last
          expect(EventUser.where(event_id: new_event.id).count == 3).to be_truthy
        end
      end

      context "戻るボタンを押したら" do
        it "リクエストが成功すること" do
          # リダイレクトではなくrenderなので302でなく200
          post admin_events_path, params: { event: event_params, back: "戻る" }
          expect(response).to have_http_status "200"
        end
      end
    end
  end
end
