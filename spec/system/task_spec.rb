require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    @user = User.create(name: "test", email: "test@gmail.com", password: "123456", password_confirmation: "123456")
    @user_second = User.create(name: "test2", email: "test2@gmail.com", password: "123456", password_confirmation: "123456")
    FactoryBot.create(:task, user_id: @user.id)
    FactoryBot.create(:second_task, user_id: @user_second.id)
    visit new_session_path
    fill_in 'session[email]', with: "test@gmail.com"
    fill_in 'session[password]', with: "123456"
    click_on 'commit' 
  end
  
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "task[title]", with: "test_title"
        fill_in "task[content]", with: "test_content"
        fill_in 'task[expired_at]', with: "002021-09-01"
        select "未着手", from: 'task[status]'
        select "高", from: 'task[priority]'
        click_on "登録する"
        expect(page).to have_content "test_title"
        expect(page).to have_content "test_content"
        expect(page).to have_content "2021-09-01"
        expect(page).to have_content "未着手"
        expect(page).to have_content '高'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content "test_title"
        expect(page).to have_content "test_content"
        expect(page).to have_content "2021-08-12"
        expect(page).to have_content "未着手"
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'test_title1'
      end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
        visit tasks_path(:task)
        expect(page).to have_content "test_title"
        expect(page).to have_content "test_content"
       end
     end
  end
  describe '検索機能' do
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        visit tasks_path
        fill_in 'search_title', with: 'test'
        click_button '検索'
        expect(page).to have_content 'test'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        visit tasks_path
        select '未着手', from: 'search_status'
        click_button '検索'
        expect(page).to have_content '未着手'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        visit tasks_path
        fill_in 'search_title', with: 'test'
        select '未着手', from: 'search_status'
        click_button '検索'
        expect(page).to have_content 'test'
        expect(page).to have_content '未着手'
      end
    end
  end
end