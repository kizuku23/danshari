class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :gender, :age, :status, :layout, :area)
  end
end
