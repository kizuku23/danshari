class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :show, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def edit
  end

  def show
    @posts = @user.posts.order(id: 'DESC').page(params[:page])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: '登録内容を更新しました。'
    else
      render :edit
    end
  end

  def follows
    @users = User.find(params[:id])
  end

  def followers
    @users = User.find(params[:id])
  end

  def search
    @user_or_post = params[:option]
    if @user_or_post == "1"
      @posts = Post.search(params[:search], @user_or_post).order(id: 'DESC').page(params[:page])
    else
      @users = User.search(params[:search], @user_or_post)
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :introduction, :profile_image, :gender,
      :age, :status, :layout, :area,
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
