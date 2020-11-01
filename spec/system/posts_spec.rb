require 'rails_helper'

describe '投稿のテスト' do
  let(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  subject { page }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '新規投稿画面のテスト' do
    before do
      visit new_post_path
    end
    context '表示の確認' do
      it '新規投稿と表示される' do
        is_expected.to have_content '新規投稿'
      end
      it '写真をアップロードすると表示される' do
        is_expected.to have_content '写真をアップロードする'
      end
      it 'カテゴリーと表示される' do
        is_expected.to have_content 'カテゴリー'
      end
      it 'タグ名と表示される' do
        is_expected.to have_content 'タグ名'
      end
      it 'コメントと表示される' do
        is_expected.to have_content 'コメント'
      end
      it '新規登録ボタンが表示される' do
        is_expected.to have_button '新規登録'
      end
    end
    context '新規投稿の確認' do
      it '投稿に成功する' do
        attach_file "#{Rails.root}/spec/fixture/no-image.jpg"
        select '写真'
        click_button '新規登録'
        is_expected.to have_content 'アップロード'
      end
      it '投稿に失敗する' do
        click_button '新規登録'
        is_expected.to have_content 'エラー'
        expect(current_path).to eq posts_path
      end
    end
  end

  describe '投稿編集のテスト' do
    let!(:user2) { create(:user) }
    let!(:post2) { create(:post, user: user2) }
    context '自分の投稿の編集画面へ遷移' do
      it '遷移できる' do
        visit edit_post_path(post)
        expect(current_path).to eq edit_post_path(post)
      end
    end
    context '他人の投稿の編集画面へ遷移' do
      it '遷移できない' do
        visit edit_post_path(post2)
        expect(current_path).to eq posts_path
      end
    end
    context '表示の確認' do
      before do
        visit edit_post_path(post)
      end
      it '投稿編集と表示される' do
        is_expected.to have_content '投稿編集'
      end
      it '写真イメージと表示される' do
        is_expected.to have_content '写真イメージ'
      end
      it 'カテゴリーと表示される' do
        is_expected.to have_content 'カテゴリー'
      end
      it 'タグ名と表示される' do
        is_expected.to have_content 'タグ名'
      end
      it 'コメントと表示される' do
        is_expected.to have_content 'コメント'
      end
      it '変更を保存ボタンが表示される' do
        is_expected.to have_button '変更を保存'
      end
    end
    context 'フォームの確認' do
      it '編集に成功する' do
        visit edit_post_path(post)
        click_button '変更を保存'
        is_expected.to have_content '更新しました'
        expect(current_path).to eq post_path(post)
      end
      it '編集に失敗する' do
        visit edit_post_path(post)
        select '選択してください'
        click_button '変更を保存'
        is_expected.to have_content 'エラー'
        expect(current_path).to eq post_path(post)
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    let!(:user2) { create(:user) }
    let!(:post2) { create(:post, user: user2) }
    before do
      visit posts_path
    end
    context '表示の確認' do
      it 'すべての写真と表示される' do
        is_expected.to have_content 'すべての写真'        
      end
      it '自分と他人のプロフィールのリンク先が正しい' do
        is_expected.to have_link '', href: user_path(post.user)
        is_expected.to have_link '', href: user_path(post2.user)
      end
      it '自分と他人の投稿のリンク先が正しい' do
        is_expected.to have_link '', href: post_path(post)
        is_expected.to have_link '', href: post_path(post2)
      end
      it '自分と他人の投稿コメントが表示される' do
        is_expected.to have_content post.description
        is_expected.to have_content post2.description
      end
    end
    context 'ソートボタンの確認' do
      it 'セレクトボックスが表示される' do
        is_expected.to have_css '#keyword'
      end
      it 'ソートボタンが表示される'  do
        is_expected.to have_button 'PUSH'
      end
      it 'セレクトボックスの選択肢が正しい' do
        is_expected.to have_select 'keyword', options: ['新しい順', '古い順', 'いいね順']
      end
      it 'ソートボタンの遷移先が正しい' do
        select '新しい順', from: 'keyword'
        click_button 'PUSH'

        expect(current_path).to eq sort_path
      end
    end
  end

  describe '投稿詳細画面のテスト' do
    let!(:user2) { create(:user) }
    let!(:post2) { create(:post, user: user2) }
    context '自分・他人共通の投稿詳細画面の表示を確認' do
      before do
        visit post_path(post)
      end
      it '~さんの写真と表示される' do
        is_expected.to have_content user.name + ' さんの写真'
      end
      it '画像が表示される' do
        is_expected.to have_css "img[src*='no-image']"
      end
      it 'カテゴリーが表示される' do
        is_expected.to have_content post.category.name
      end
      it 'いいねボタンが表示される' do
        is_expected.to have_link '', href: post_likes_path(post)
      end
      it 'コメントが表示される' do
        is_expected.to have_content post.description
      end
      it 'コメントフォームが表示される' do
        is_expected.to have_field 'post_comment_comment'
      end
      it 'コメントボタンが表示される' do
        is_expected.to have_button 'コメントする'
      end
    end
    context '自分の投稿詳細画面の表示を確認' do
      it '投稿の編集リンクが表示される' do
        visit post_path(post)
        is_expected.to have_link '編集', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        visit post_path(post)
        is_expected.to have_link '削除', href: post_path(post)
      end
    end
    context '他人の投稿詳細画面の表示を確認' do
      it '投稿の編集リンクが表示されない' do
        visit post_path(post2)
        is_expected.to have_no_link '編集', href: edit_post_path(post2)
      end
      it '投稿の削除リンクが表示されない' do
        visit post_path(post2)
        is_expected.to have_no_link '削除', href: post_path(post2)
      end
    end
  end
end
