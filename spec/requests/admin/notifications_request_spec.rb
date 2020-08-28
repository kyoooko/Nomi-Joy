require 'rails_helper'

RSpec.describe "Admin::Notifications", type: :request do
  # ユーザー１はログインユーザー
  let!(:user_1) { create(:user) }
  # ユーザー２はログインユーザーではない
  let!(:user_2) { create(:user) }

  describe "通知ページ(GET #show)" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get admin_notifications_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user_1
      end

      it "リクエストが成功すること" do
        get admin_notifications_path
        expect(response).to have_http_status "200"
      end
    end
  end

  # DM送信（ユーザー１がユーザー２にDMを送る）
  let!(:follow_1to2) { Relationship.create(following_id: user_1.id, follower_id: user_2.id) }
  let!(:follow_2to1) { Relationship.create(following_id: user_2.id, follower_id: user_1.id) }
  let!(:room) { Room.create }
  let!(:entry_1at1) { Entry.create(user_id: user_1.id, room_id: room.id) }
  let!(:entry_2at1) { Entry.create(user_id: user_2.id, room_id: room.id) }
  let (:req_params) { { direct_message: { room_id: room.id, message: "hoge" } } }

  describe "通知作成(POST #create)" do
    context "ユーザー１からユーザー２へDMを送信(POST #create)した時" do
      before do
        sign_in user_1
        # rooms/showでsession[:user_id] = @user.idをしているのでrooms/showを経ないとsessionに値が入らない
        get admin_room_path user_2.id
        post admin_direct_messages_path, params: req_params, xhr: true
      end
      it "ユーザー１からユーザー２への通知が作成されること" do
        # direct_message_idは1とかぎらない。今回のテストではそもそもDMひとつしか作っていないのでdirect_message_id指定しなくても問題ない
        expect(Notification.find_by(visitor_id: user_1.id, visited_id: user_2.id, action: "dm")).to be_truthy
      end
    end
  end

  # ノミカイ招待（ユーザー１がユーザー２を招待）
  let!(:restaurant) { create(:restaurant, user_id: user_1.id) }
  # let!(:event) { create(:event, restaurant_id: restaurant.id, user_id: user_1.id) }
  # let!(:event_user_1) { create(:event_user, user_id: user_1.id, event_id: event.id) }
  # let!(:event_user_2) { create(:event_user, user_id: user_2.id, event_id: event.id) }
  let (:event_params) { { event: { name: "野澤さん送別会", date: "2020-07-30 00:00:00", begin_time: "2020-07-30 18:00:00",  finish_time: "2020-07-30 20:00:00", memo: "花束用意する"} } }

  # describe "通知作成(POST #create)" do
  #   context "ユーザー１がノミカイを新規作成しユーザー２を招待した時" do
  #     before do
  #       sign_in user_1
  #       # get admin_room_path user_2.id
  #       # ここ書く！！！！！！！！！！！！！
  #       post admin_events_path, params: event_params, xhr: true
  #     end
  #     it "ユーザー１からユーザー２への通知が作成されること" do
  #       expect(Notification.find_by(visitor_id: user_1.id, visited_id: user_2.id, action: "create_event")).to be_truthy
  #     end
  #   end
  # end

  # ノミカイリマインド（ユーザー１がユーザー２を招待）
  # describe "通知作成(POST #create)" do
  #   context "ユーザー１(カンジ）がユーザー２へリマインドを送った時" do
  #     before do
  #       sign_in user_1
  #     end
  #     it "ユーザー１からユーザー２への通知が作成されること" do
        
  #     end
  #   end
  # end

  # # 前日ノミカイリマインド（ユーザー１がユーザー２を招待／定時処理）
  # describe "通知作成(POST #create)" do
  #   context "ノミカイの前日AM８時になったら（カンジ：ユーザー１、参加者：ユーザー２）" do
  #     before do
  #       sign_in user_1
  #     end
  #     it "ユーザー１からユーザー２への通知が作成されること" do
        
  #     end
  #   end
  # end






# ノミカイ（ユーザー１がカンジでユーザー２は会費未払い）
# let!(:restaurant) { create(:restaurant, user_id: user_1.id) }
# let!(:event) { create(:event, restaurant_id: restaurant.id, user_id: user_1.id) }
# let!(:event_user_1) { create(:event_user, user_id: user_1.id, event_id: event.id) }
# let!(:event_user_2) { create(:event_user, user_id: user_2.id, event_id: event.id, fee_status: false) }

end
