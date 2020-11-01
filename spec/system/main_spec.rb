require 'rails_helper'

describe 'ユーザー権限のテスト'  do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  subject { current_path }

  describe 'ログインしていない場合' do
    context '投稿関連のURLにアクセス' do
      it '一覧画面に遷移できない' do
        visit posts_path
        is_expected.to eq new_user_session_path
      end
      it '編集画面に遷移できない' do
        visit edit_post_path(post)
        is_expected.to eq new_user_session_path
      end
      it '詳細画面に遷移できない' do
        visit post_path(post)
        is_expected.to eq new_user_session_path
      end
    end
  end

  describe 'ログインしていない場合にユーザー関連のURLにアクセス' do
    context 'ユーザー関連のURLにアクセス' do
      it '一覧画面に遷移できない' do
        visit search_path
        is_expected.to eq new_user_session_path
      end
      it '編集画面に遷移できない' do
        visit edit_user_registration_path(user)
        is_expected.to eq new_user_session_path
      end
      it '詳細画面に遷移できない' do
        visit user_path(user)
        is_expected.to eq new_user_session_path
      end
    end
  end
end
