require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
    subject { test_user.valid? }

    context 'nameカラム' do
      let(:test_user) { user }
      it '空欄でないこと' do
        test_user.name = ''
        is_expected.to eq false;
      end
      it '2文字以上であること' do
        test_user.name = Faker::Lorem.characters(number:1)
        is_expected.to eq false;
      end
      it '10文字以下であること' do
        test_user.name = Faker::Lorem.characters(number:11)
        is_expected.to eq false;
      end
    end
    context 'introductionカラム' do
      let(:test_user) { user }
      it '1000文字以下であること' do
        test_user.name = Faker::Lorem.characters(number:1001)
        is_expected.to eq false;
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
    context 'PostCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている(follower)' do
        expect(User.reflect_on_association(:follower).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている(followed)' do
        expect(User.reflect_on_association(:followed).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている(following_user)' do
        expect(User.reflect_on_association(:following_user).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている(follower_user)' do
        expect(User.reflect_on_association(:follower_user).macro).to eq :has_many
      end
    end
  end
end
