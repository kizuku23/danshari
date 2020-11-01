require 'rails_helper'

RSpec.describe 'Categoryモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Category.reflect_on_association(:post).macro).to eq :has_one
      end
    end
  end
end
