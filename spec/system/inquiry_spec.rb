require 'rails_helper'

describe 'お問い合わせ' do
  subject { page }

  describe 'お問い合わせ画面のテスト' do
    before do
      visit user_session_path
    end
    context 'お問い合わせ画面への遷移' do
      it '遷移できる' do
        click_link 'サポートに問い合わせる'
        expect(current_path).to eq inquiry_path
      end
    end
    context '表示の確認' do
      before do
        visit inquiry_path
      end
      it 'お問い合わせと表示される' do
        is_expected.to have_content 'お問い合わせ'
      end
      it '名前入力フォームが表示される' do
        is_expected.to have_field 'inquiry_name'
      end
      it 'メールアドレス入力フォームが表示される' do
        is_expected.to have_field 'inquiry_email'
      end
      it 'お問い合わせ内容入力フォームが表示される' do
        is_expected.to have_field 'inquiry_message'
      end
      it '確認ボタンが表示される' do
        is_expected.to have_button '確認'
      end
    end
  end

  describe '確認画面のテスト' do
    before do
      visit inquiry_path
    end
    context '確認画面への遷移' do
      it '遷移できる' do
        fill_in 'inquiry[name]', with: 'hoge'
        fill_in 'inquiry[email]', with: 'foo@bar'
        fill_in 'inquiry[message]', with: 'hoge'
        click_button '確認'
        expect(current_path).to eq inquiry_confirm_path
      end
      it '遷移できない' do
        fill_in 'inquiry[name]', with: ''
        fill_in 'inquiry[email]', with: ''
        fill_in 'inquiry[message]', with: ''
        click_button '確認'
        is_expected.to have_content 'エラー'
        expect(current_path).to eq inquiry_confirm_path
      end
    end
    context '表示の確認' do
      before do
        fill_in 'inquiry[name]', with: 'hoge'
        fill_in 'inquiry[email]', with: 'foo@bar'
        fill_in 'inquiry[message]', with: 'hoge'
        click_button '確認'
      end
      it 'お問い合わせと表示される' do
        is_expected.to have_content 'お問い合わせ'
      end
      it '名前が表示される' do
        is_expected.to have_content 'hoge'
      end
      it 'メールアドレスが表示される' do
        is_expected.to have_content 'foo@bar'
      end
      it '問い合わせ内容が表示される' do
        is_expected.to have_content 'hoge'
      end
      it '送信ボタンが表示される' do
        is_expected.to have_button '送信'
      end
    end
  end
end
