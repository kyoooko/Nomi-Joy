require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  # describe 'バリデーションのテスト' do
  #   let(:user) { create(:user) }
  #   let!(:restaurant) { build(:restaurant, user_id: user.id) }
  #   context 'nameカラム' do
  #     it '空欄でないこと' do
  #       restaurant.name= ''
  #       expect(restaurant.valid?).to eq false
  #    end
  #   end
  # end

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
    context 'Evnetモデルとの関係' do
      let(:target) { :events }
      it '1:Nとなっている' do
        expect(association.macro).to eq :has_many
      end
    end
  end
end
