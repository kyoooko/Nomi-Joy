require 'rails_helper'

RSpec.describe EventUser, type: :model do
  describe 'バリデーションのテスト' do
    subject { event_user.valid? }

    let(:user) { create(:user) }
    let(:restaurant) { create(:restaurant, user_id: user.id) }
    let(:event) { create(:event, restaurant_id: restaurant.id, user_id: user.id) }
    let(:event_user) { create(:event_user, user_id: user.id, event_id: event.id) }

    context 'feeカラム' do
      it '半角英数字であること' do
        event_user.fee = '３０００'
        expect(event_user.fee).not_to eq '３０００'
      end
    end
  end

  describe 'アソシエーションのテスト' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'Userモデルとの関係' do
      let(:target) { :user }

      it 'N:1となっている' do
        expect(association.macro).to eq :belongs_to
      end
    end

    context 'Eventモデルとの関係' do
      let(:target) { :event }

      it 'N:1となっている' do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
end
