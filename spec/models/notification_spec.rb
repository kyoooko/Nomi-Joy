require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'アソシエーションのテスト' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'Userモデル(visitor)との関係' do
      let(:target) { :visitor }

      it 'N:1となっている' do
        expect(association.macro).to eq :belongs_to
      end
    end

    context 'Userモデル(visited)との関係' do
      let(:target) { :visited }

      it 'N:1となっている' do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
end
