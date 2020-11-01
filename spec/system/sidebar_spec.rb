require 'rails_helper'

describe 'サイドバーのテスト' do

  describe 'ログインしていない場合' do
    before do
      visit root_path
    end
    context 'サイドバーの表示を確認' do
      subject { page }
      it 'ヘッドラインが表示される' do
        is_expected.to have_content 'MENU'
        is_expected.to have_content 'CATEGORY'
      end
      it 'HOMEリンクが表示される' do
        is_expected.to have_link 'HOME'
      end
      it 'ABOUTリンクが表示される' do
        is_expected.to have_link 'ABOUT'
      end
      it 'LOG INリンクが表示される' do
        is_expected.to have_link 'LOG IN'
      end
      it 'PHOTOSリンクが表示される' do
        is_expected.to have_link 'PHOTOS'
      end
      it 'IDEASリンクが表示される' do
        is_expected.to have_link 'IDEAS'
      end
      it 'PROFILEリンクが表示されない' do
        is_expected.to have_no_link 'PROFILE'
      end
      it 'LOG OUTリンクが表示されない' do
        is_expected.to have_no_link 'LOG OUT'
      end
    end
    context 'サイドバーのリンクを確認' do
      subject { current_path }
      it 'HOME画面に遷移する' do
        within first('.nav-li') do
          click_link 'HOME'
        end
        is_expected.to eq root_path
      end
      it 'ABOUT画面に遷移する' do
        within all('.nav-li')[1] do
          click_link 'ABOUT'
        end
        is_expected.to eq about_path
      end
      it 'ログイン画面に遷移する' do
        within all('.nav-li')[2] do
          click_link 'LOG IN'
        end
        is_expected.to eq new_user_session_path
      end
      it 'PHOTOS（写真一覧）に遷移できない' do
        within all('.nav-li')[3] do
          click_link 'PHOTOS'
        end
        is_expected.to eq new_user_session_path
        expect(page).to have_content 'ログインしてください'
      end
      it 'IDEAS（アイデア一覧）に遷移できない' do
        within all('.nav-li')[4] do
          click_link 'IDEAS'
        end
        is_expected.to eq new_user_session_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログインしている場合' do
    let(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end
    context 'サイドバーの表示を確認' do
      subject { page }
      it 'ヘッドラインが表示される' do
        is_expected.to have_content 'MENU'
        is_expected.to have_content 'CATEGORY'
      end
      it 'HOMEリンクが表示される' do
        is_expected.to have_link 'HOME'
      end
      it 'PROFILEリンクが表示される' do
        is_expected.to have_link 'PROFILE'
      end
      it 'UPLOADリンクが表示される' do
        is_expected.to have_link 'UPLOAD'
      end
      it 'LOG OUTリンクが表示される' do
        is_expected.to have_link 'LOG OUT'
      end
      it 'PHOTOSリンクが表示される' do
        is_expected.to have_link 'PHOTOS'
      end
      it 'IDEASリンクが表示される' do
        is_expected.to have_link 'IDEAS'
      end
      it 'ABOUTリンクが表示されない' do
        is_expected.to have_no_link 'ABOUT'
      end
      it 'LOG INリンクが表示されない' do
        is_expected.to have_no_link 'LOG IN'
      end
    end
    context 'サイドバーのリンクを確認' do
      subject { current_path }
      it 'HOME画面に遷移する' do
        within first('.nav-li') do
          click_link 'HOME'
        end
        is_expected.to eq root_path
      end
      it 'PROFILE画面に遷移する' do
        within all('.nav-li')[1] do
          click_link 'PROFILE'
        end
        is_expected.to eq user_path(user)
      end
      it 'UPLOAD画面に遷移する' do
        within all('.nav-li')[2] do
          click_link 'UPLOAD'
        end
        is_expected.to eq new_post_path
      end
      it 'LOG OUTする' do
        within all('.nav-li')[3] do
          click_link 'LOG OUT'
        end
        is_expected.to eq root_path
        expect(page).to have_content 'ログアウト'
      end
      it 'PHOTOS(写真一覧画面)に遷移する' do
        within all('.nav-li')[4] do
          click_link 'PHOTOS'
        end
        is_expected.to eq('/posts/category/' + 1.to_s)
      end
      it 'IDEAS(アイデア一覧画面)に遷移する' do
        create(:category, id: 2, name: 'アイデア')
        within all('.nav-li')[5] do
          click_link 'IDEAS'
        end
        is_expected.to eq('/posts/category/' + 2.to_s)
      end
    end
  end
end
