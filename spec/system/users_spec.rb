require 'rails_helper'

describe 'ユーザー認証のテスト' do
  subject { page }

  describe 'ユーザー新規登録' do
    before do
      visit new_user_registration_path
    end
    context '新規登録画面に遷移' do
      it '新規登録に成功する' do
        fill_in 'user[name]', with: Faker::Internet.username(specifier: 2..10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '新規登録'

        is_expected.to have_content 'アカウント登録を受け付けました'
      end
      it '新規登録に失敗する' do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button '新規登録'

        is_expected.to have_content 'エラー'
      end
    end
  end

  describe 'ユーザーログイン' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
    end
    context 'ログイン画面に遷移' do
      let(:test_user) { user }
      it 'ログインに成功する' do
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'

        is_expected.to have_content 'ログインしました'
      end
      it 'ログインに失敗する' do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'

        is_expected.to have_content '違います'
      end
    end
  end
end

describe 'ユーザーのテスト' do
  let(:user) { create(:user) }
  let!(:test_user2) { create(:user) }
  let!(:post) { create(:post, user: user) }
  subject { page }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  describe 'サイドバーのテスト' do
    before do
      visit user_path(user)
    end
    context '表示の確認' do
      it 'PROFILEと表示される' do
        is_expected.to have_content 'PROFILE'
      end
      it 'プロフィール画像が表示される' do
        is_expected.to have_css "img[src*='no-image']"
      end
      it '名前が表示される' do
        is_expected.to have_content user.name
      end
      it '自己紹介が表示される' do
        is_expected.to have_content user.introduction
      end
      it '編集リンクが表示される' do
        is_expected.to have_link '', href: edit_user_registration_path(user)
      end
      it 'フォローリンクが表示される' do
        is_expected.to have_link '', href: user_follows_path(user)
      end
      it 'フォロワーリンクが表示される' do
        is_expected.to have_link '', href: user_followers_path(user)
      end
    end
    context 'フォローボタンの表示の確認' do
      it '自分の詳細画面でフォローボタンが表示されない' do
        is_expected.to have_no_button 'フォロー'
      end
      it '他人の詳細画面でフォロー/フォロー中ボタンが表示される' do
        visit user_path(test_user2)
        is_expected.to have_css '.fbtn'
      end
    end
  end

  describe '編集のテスト' do
    context '自分の編集画面への遷移' do
      it '遷移できる' do
        visit edit_user_registration_path(user)
        expect(current_path).to eq('/users/' + user.id.to_s + '/edit')
      end
    end
    context '他人の編集画面への遷移' do
      it '遷移できない' do
        visit edit_user_registration_path(test_user2)
        expect(current_path).to eq('/users/' + test_user2.id.to_s + '/edit')
      end
    end
    context '表示の確認' do
      before do
        visit edit_user_registration_path(user)
      end
      it 'プロフィール編集と表示される' do
        is_expected.to have_content 'プロフィール編集'
      end
      it 'プロフィール画像と表示される' do
        is_expected.to have_content 'プロフィール画像'
      end
      it '画像プレビューが表示される' do  
        is_expected.to have_css '.prev'
      end
      it 'ファイルを選択が表示される' do
        is_expected.to have_field 'user[profile_image]'
      end
      it '名前編集フォームに自分の名前が表示される' do
        is_expected.to have_field 'user[name]', with: user.name
      end
      it 'メールアドレスフォームに自分のメールアドレスが表示される' do
        is_expected.to have_field 'user[email]', with: user.email
      end
      it '性別フォームに自分の性別が表示される' do
        is_expected.to have_field 'user[gender]', with: user.gender
      end
      it '年代フォームに自分の年代が表示される' do
        is_expected.to have_field 'user[age]', with: user.age
      end
      it '居住形態フォームに自分の居住形態が表示される' do
        is_expected.to have_field 'user[status]', with: user.status
      end
      it '間取りフォームに自分の間取りが表示される' do
        is_expected.to have_field 'user[layout]', with: user.layout
      end
      it '広さフォームに自分の広さが表示される' do
        is_expected.to have_field 'user[area]', with: user.area
      end
      it '自己紹介フォームに自分の自己紹介が表示される' do
        is_expected.to have_field 'user[introduction]', with: user.introduction
      end
      it '変更を保存ボタンが表示される' do
        is_expected.to have_button '変更を保存'
      end
      it '編集に成功する' do
        click_button '変更を保存'
        is_expected.to have_content '更新しました'
        expect(current_path).to eq('/users/' + user.id.to_s)
      end
      it '編集に失敗する' do
        fill_in 'user[name]', with: ''
        click_button '変更を保存'
        is_expected.to have_content 'エラー'
        expect(current_path).to eq('/users')
      end
    end
  end

  describe 'ユーザー一覧画面のテスト' do
    before do
      visit root_path
    end
    context 'ユーザー一覧画面への遷移' do
      it '遷移できる' do
        within find_by_id('search-hide') do
          select 'ユーザーを探す'   
          find('.sbtn').click
        end
        expect(current_path).to eq search_path
      end
    end
    context 'フォロー/フォロワー一覧画面への遷移' do
      before do
        visit user_path(user)
      end
      it 'フォロー画面に遷移できる' do
        within all('.profile-info-item')[5] do
          click_link 'フォロー'
        end
        is_expected.to have_content 'フォローリスト'
        expect(current_path).to eq user_follows_path(user)
      end
      it 'フォロワー画面に遷移できる' do
        within all('.profile-info-item')[5] do
          click_link 'フォロワー'
        end
        is_expected.to have_content 'フォロワーリスト'
        expect(current_path).to eq user_followers_path(user)
      end
    end
  end

  describe 'ユーザー詳細画面のテスト' do
    before do
      visit user_path(user)
    end
    context '表示の確認' do
      it '~さんの写真と表示される' do
        is_expected.to have_content user.name + ' さんの写真'
      end
    end
  end
end
