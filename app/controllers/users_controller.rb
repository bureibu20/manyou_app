class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[new create]
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)  
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice:"登録が完了しました！"
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks
  end

  def edit
    
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice:"情報を編集しました！"
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to new_user_path, notice:"ユーザー情報を削除しました！"
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
