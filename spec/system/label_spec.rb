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
end