require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'バリデーションのテスト' do
    subject { todo.valid? }

    let(:user) { create(:user) }
    let!(:todo) { build(:todo, user_id: user.id) }

    context 'taskカラム' do
      it '空欄でないこと' do
        todo.task = ''
        expect(todo.valid?).to eq false
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
  end
end
