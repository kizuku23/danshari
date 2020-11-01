require 'rails_helper'

describe 'ヘッダーのテスト' do
  let(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  subject { page }
  context 'ロゴを確認' do
    it 'ロゴが表示される' do
      is_expected.to have_content 'dan sha ri'
    end
    it 'ロゴのリンクを確認' do
      click_link 'dan sha ri'
      expect(current_path).to eq root_path
    end
  end
  context '検索フォームを確認' do
    it 'セレクトボックスが表示される' do
      is_expected.to have_css '#option'
    end
    it 'セレクトボックスの選択肢が正しい' do
      is_expected.to have_select 'option', options: ['写真を探す', 'ユーザーを探す']
    end
    it 'サーチボックスが表示される' do
      is_expected.to have_css '#search'
    end
    it 'サーチボックスにキーワードを入力が表示されている' do
      is_expected.to have_field 'search', placeholder: 'キーワードを入力'
    end
    it 'サーチボタンが表示される' do
      is_expected.to have_button 'button'
    end
    it 'サーチボタンの遷移先が正しい' do
      within '#search-hide' do
        select '写真を探す', from: 'option'
        click_button 'button'
      end
      expect(current_path).to eq search_path
    end
  end
end
