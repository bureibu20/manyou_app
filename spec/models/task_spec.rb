require 'rails_helper'
describe 'タスクモデル機能', type: :model do
  before do
    #User.creatをすることによってid番号が作られる。それをTaskのuser_idカラムにuser.idで入れ込む
    @user = User.create(name: "test", email: "test@gmail.com", password: "123456", password_confirmation: "123456")
  end
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(title: '', content: '失敗テスト')
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(title: "失敗テスト", content: "")
        expect(task).to be_invalid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        #@userはbeforeで作ったインスタンス変数
        task = Task.new(title: "テスト", content: "成功", status: '未着手', expired_at: '2021-05-01 00:00:00', priority: '中', user_id: @user.id)
        expect(task).to be_valid
      end
    end
  end
  describe '検索機能' do
    let!(:task) { FactoryBot.create(:task, title: 'task', expired_at: '2021-08-10 00:00:00', status: '未着手', user_id: @user.id) }
    let!(:second_task) { FactoryBot.create(:second_task, title: "sample", user_id: @user.id) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(Task.search_title('task')).to include(task)
        expect(Task.search_title('task')).not_to include(second_task)
        expect(Task.search_title('task').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_status('未着手')).to include(task)
        expect(Task.search_status('未着手').count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(Task.search_title('task')).to include(task)
        expect(Task.search_title('task')).not_to include(second_task)
        expect(Task.search_title('task').count).to eq 1
        expect(Task.search_status('未着手')).to include(task)
        expect(Task.search_status('未着手').count).to eq 1
      end
    end
  end
end
