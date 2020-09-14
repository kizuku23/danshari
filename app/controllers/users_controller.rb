class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(id: 'DESC').page(params[:page]).per(9)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: '登録内容を更新しました。'
    else
      render :edit
    end
  end

  def follows
  end

  def followers
  end

  def search
    @user_or_post = params[:option]
    if @user_or_post == "1"
      @posts = Post.search(params[:search], @user_or_post).order(id: 'DESC').page(params[:page]).per(9)
    else
      @users = User.search(params[:search], @user_or_post)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :gender, :age, :status, :layout, :area)
  end
end
