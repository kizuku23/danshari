require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
    let!(:post) { build(:post, user_id: user.id) }
    subject { post.valid? }

    context 'imageカラム' do
      it '空欄でないこと' do
        post.image = ''
        is_expected.to eq false;
      end
    end
    context 'categoryカラム' do
      it '空欄でないこと' do
        post.category = nil
        is_expected.to eq false;
      end
    end
    context 'descriptionカラム' do
      it '1000文字以下であること' do
        post.description = Faker::Lorem.characters(number:1001)
        is_expected.to eq false;
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Categoryモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:category).macro).to eq :belongs_to
      end
    end
    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
    context 'PostCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end
  end
end
