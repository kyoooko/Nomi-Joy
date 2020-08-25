require 'rails_helper'

RSpec.describe DirectMessage, type: :model do
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
      let(:target) { :room }

      it 'N:1となっている' do
        expect(association.macro).to eq :belongs_to
      end
    end
  end

  describe 'バリデーションのテスト' do
    subject { direct_message.valid? }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let(:direct_message) { create(:direct_message, user_id: user.id, room_id: room.id) }

    context 'messageカラム' do
      it '空欄でないこと' do
        direct_message.message = ''
        is_expected.to eq false
      end
    end
  end
end
