require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'バリデーションのテスト' do
    subject { event.valid? }

    let(:user) { create(:user) }
    let(:restaurant) { create(:restaurant, user_id: user.id) }
    let!(:event) { build(:event, restaurant_id: restaurant.id, user_id: user.id) }

    context 'nameカラム' do
      it '空欄でないこと' do
        event.name = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        event.name = ''
        event.valid?
        expect(event.errors[:name]).to include("を入力してください")
      end
    end

    context 'dateカラム' do
      it '空欄でないこと' do
        event.date = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        event.date = ''
        event.valid?
        expect(event.errors[:date]).to include("を入力してください")
      end
    end

    context 'begin_timeカラム' do
      it '空欄でないこと' do
        event.begin_time = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        event.begin_time = ''
        event.valid?
        expect(event.errors[:begin_time]).to include("を入力してください")
      end
    end

    context 'finish_time' do
      it '空欄でないこと' do
        event.finish_time = ''
        is_expected.to eq false
      end
      it '空欄の場合はエラーが出る' do
        event.finish_time = ''
        event.valid?
        expect(event.errors[:finish_time]).to include("を入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context 'Restaurantモデルとの関係' do
      let(:target) { :restaurant }

      it 'N:1となっている' do
        expect(association.macro).to eq :belongs_to
      end
    end

    context 'EventUserモデルとの関係' do
      let(:target) { :event_users }

      it '1:Nとなっている' do
        expect(association.macro).to eq :has_many
      end
    end

    context 'Notificationモデルとの関係' do
      let(:target) { :notifications }

      it '1:Nとなっている' do
        expect(association.macro).to eq :has_many
      end
    end
  end
end
