require 'rails_helper'

RSpec.describe Restaurant, type: :model do
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
