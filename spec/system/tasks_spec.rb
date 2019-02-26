require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    # ユーザーAとBを作成しておく
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }

    before do
      # 作成者がユーザーAにあるタスクを作成しておく
      FactoryBot.create(:task, name: '最初のタスク', user: user_a)
      # ユーザーAでログインする
      visit login_path
      # メールアドレスを入力
      fill_in 'メールアドレス', with: login_user.email
      # パスワードを入力
      fill_in 'パスワード', with: login_user.password
      # 「ログインする」ボタンを押す
      click_button 'ログインする'
    end

    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it 'ユーザーAが作成したタスクが表示される' do
        # 作成済みのタスクの名称が画面上に表示されていることを確認
        # page（画面）に「最初のタスク」という内容が含まれていることを期待する
        expect(page).to have_content '最初のタスク'
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'ユーザーAのタスクが表示表示されていないことを確認する' do
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end
end