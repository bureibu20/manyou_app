require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
  end
  
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "task[title]", with: "test_title"
        fill_in "task[content]", with: "test_content"
        fill_in 'task[expired_at]', with: "002021-09-01"
        select "未着手", from: 'task[status]'
        click_on "登録する"
        expect(page).to have_content "test_title"
        expect(page).to have_content "test_content"
        expect(page).to have_content "2021-09-01"
        expect(page).to have_content "未着手"
        
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
end