# メール
# show(タブ１）
# send_remind

# show(タブ３）
# notice_to_unpaying_users

# 備忘録：下記イベントユーザーでやる（リクエストスペックのfee_update／領収済みユーザーは金額変更できないテストできずのため）

# ユーザー２は支払済
# let!(:event_user_2) { create(:event_user, user_id: user_2.id, event_id: event.id, fee_status: true) }

# context "支払済ユーザーの場合" do
#   it "金額が更新されないこと" do
#     patch admin_event_users_fee_path(event_user_2.id), params: { event_user: event_user_params }, xhr: true
#     binding.pry
#     expect(event_user.reload.fee).to eq 3000
#   end
# end
