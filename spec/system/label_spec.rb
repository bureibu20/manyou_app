require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    @user = User.create(name: "test", email: "test@gmail.com", password: "123456", password_confirmation: "123456")
    @user_second = User.create(name: "test2", email: "test2@gmail.com", password: "123456", password_confirmation: "123456")
    FactoryBot.create(:task, user_id: @user.id)
    FactoryBot.create(:second_task, user_id: @user_second.id)
    @label = FactoryBot.create(:label)
    @label_second = FactoryBot.create(:second_label)
    visit new_session_path
    fill_in 'session[email]', with: "test@gmail.com"
    fill_in 'session[password]', with: "123456"
    click_on 'commit' 
    visit new_task_path
    check "task_label_ids_#{@label.id}"
    fill_in "task[title]", with: "test_title"
    fill_in "task[content]", with: "test_content"
    fill_in 'task[expired_at]', with: "002021-09-01"
    select "未着手", from: 'task[status]'
    select "高", from: 'task[priority]'
    select "高", from: 'task[priority]'
    click_on "登録する"
  end
  
  describe 'ラベル機能確認' do
    context 'ラベルを新規作成した場合' do
      it '作成したラベルが表示される' do
        expect(page).to have_content 'test1'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'タスクにつけたラベルの内容が表示される' do
        click_on 'Back'
        all('.index_list')[1].click_link '詳細'
        expect(page).to have_content 'test1'
      end
    end
  end
  describe '検索機能' do
    context 'ラベル検索をした場合' do
      it "検索したラベルがついているタスクが絞り込まれる" do
        click_on 'Back'
        select 'test1', from: 'label_id'
        click_button '検索'
        expect(page).to have_content 'test1'
      end
    end
  end
end