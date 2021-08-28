require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    @user = User.create(name: "test", email: "test@gmail.com", password: "123456", password_confirmation: "123456")
    @user_second = User.create(name: "test2", email: "test2@gmail.com", password: "123456", password_confirmation: "123456")
    FactoryBot.create(:task, user_id: @user.id)
    FactoryBot.create(:second_task, user_id: @user_second.id)
    FactoryBot.create(:label)
    FactoryBot.create(:second_label)
    visit new_session_path
    fill_in 'session[email]', with: "test@gmail.com"
    fill_in 'session[password]', with: "123456"
    click_on 'commit' 
  end
  
  describe 'ラベル機能確認' do
    context 'ラベルを新規作成した場合' do
      it '作成したラベルが表示される' do
        visit new_task_path
        binding.irb
        check "test1"
        fill_in "task[title]", with: "test_title"
        check 'task_label_ids_63' 
        fill_in "task[content]", with: "test_content"
        fill_in 'task[expired_at]', with: "002021-09-01"
        select "未着手", from: 'task[status]'
        select "高", from: 'task[priority]'
        select "高", from: 'task[priority]'
        click_on "登録する"
        expect(page).to have_content 'test1'
      end
    end
  end
end