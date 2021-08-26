require 'rails_helper'
describe 'ユーザー登録のテスト', type: :system do
  context 'ユーザーの新規登録' do
    it 'ユーザの新規登録ができること' do
      visit new_user_path
      fill_in 'user_name', with: 'test_user1'
      fill_in 'user_email', with: 'test1@gmail.com'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      click_on 'commit'
      click_on 'Profile'
      expect(page).to have_content 'test_user1'
    end
  end
  context 'ユーザーがログインしていない場合' do
    it 'タスク一覧に飛ぼうとした時、ログイン画面に遷移すること' do
    visit tasks_path
    expect(page).to have_content 'ログイン画面'
    end
  end
end
describe 'セッション機能のテスト' do
  context 'ユーザーがログインしている場合' do
    before do
      @user = User.create(name: "test", email: "test@gmail.com", password: "123456", password_confirmation: "123456")
      @user_second = User.create(name: "test2", email: "test2@gmail.com", password: "123456", password_confirmation: "123456")
      FactoryBot.create(:task, user_id: @user.id)
      FactoryBot.create(:second_task, user_id: @user_second.id)
      visit new_session_path
      fill_in 'session_email', with: 'test2@gmail.com'
      fill_in 'session_password', with:'123456'
      click_button 'Log in'
    end
    it 'ログインができており、マイページに飛べること' do
      expect(page).to have_content 'test2@gmail.com'
    end
    it '他人のページの詳細画面に飛ぶとタスク一覧画面に遷移すること' do
      visit user_path(@user.id)
      expect(page).to have_content 'タスク一覧'
    end
    it 'ログアウトができること' do
      click_link 'Logout'
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
describe '管理画面のテスト' do
  before do
    @user = User.create(name: "test", email: "test@gmail.com", password: "123456", password_confirmation: "123456", admin: "true")
    @user_second = User.create(name: "test2", email: "test2@gmail.com", password: "123456", password_confirmation: "123456", admin: "false" )
    FactoryBot.create(:task, user_id: @user.id)
    FactoryBot.create(:second_task, user_id: @user_second.id)
    visit new_session_path
  end
  context '管理ユーザは管理画面にアクセスできること' do
    
    it '管理ユーザは管理画面にアクセスできること' do
      fill_in 'session_email', with: 'test@gmail.com'
      fill_in 'session_password', with:'123456'
      click_on 'Log in'
      click_link 'タスク一覧'
      click_button '管理者画面'
      expect(page).to have_content '管理画面'
    end
  end  
  context '一般ユーザは管理画面にアクセスできないこと' do
    it '一般ユーザは管理画面にアクセスできないこと' do
      fill_in 'session_email', with: 'test2@gmail.com'
      fill_in 'session_password', with:'123456'
      click_on 'Log in'
      visit admin_users_path
      expect(page).to have_content '管理者以外はアクセスできません'
    end
  end
  context '管理ユーザはユーザの新規登録ができること' do
    before do
      fill_in 'session[email]', with: 'test@gmail.com'
      fill_in 'session[password]', with: '123456'
      click_on 'Log in'
    end
    it '管理ユーザはユーザの新規登録ができること' do
      click_link 'タスク一覧'
      visit admin_users_path
      click_on '新規ユーザー登録'
      fill_in 'user[name]', with: 'User777'
      fill_in 'user[email]', with: 'user777@gmail.com'
      fill_in 'user[password]', with: '123456'
      fill_in 'user[password_confirmation]', with: '123456'
      click_on 'アカウント登録'
      expect(page).to have_content '登録が完了しました'
    end
  end
  context '管理ユーザはユーザの詳細画面にアクセスできること' do
    before do
      fill_in 'session[email]', with: 'test@gmail.com'
      fill_in 'session[password]', with: '123456'
      click_on 'Log in'
    end
    it '管理ユーザはユーザの詳細画面にアクセスできること' do
      visit admin_users_path
      all('.admin_index')[1].click_on '詳細'
      expect(page).to have_content 'test2@gmail.com'
    end
  end
  context '管理ユーザはユーザの編集画面からユーザを編集できること' do
    before do
      fill_in 'session[email]', with: 'test@gmail.com'
      fill_in 'session[password]', with: '123456'
      click_on 'Log in'
    end
    it '管理ユーザはユーザの編集画面からユーザを編集できること' do
      visit admin_users_path
      all('.admin_index')[1].click_on '編集'
      fill_in 'user[name]', with: 'User777'
      fill_in 'user[email]', with: 'user777@gmail.com'
      fill_in 'user[password]', with: '123456'
      fill_in 'user[password_confirmation]', with: '123456'
      click_on 'アカウント更新'
      expect(page).to have_content '情報を編集しました'
    end
  end
  context '管理ユーザはユーザの削除をできること' do
    before do
      visit new_session_path
      fill_in 'session[email]', with: 'test@gmail.com'
      fill_in 'session[password]', with: '123456'
      click_on 'Log in'
    end
    it '管理ユーザはユーザの削除をできること' do
      visit admin_users_path
      all('.admin_index')[1].click_on '削除'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content 'ユーザー情報を削除しました'
    end
  end
end