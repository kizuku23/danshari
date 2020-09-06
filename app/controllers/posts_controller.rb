class PostsController < ApplicationController
  before_action :authenticate_user!

  def top
  end

  def about
  end

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: "写真を投稿しました"
    else
      @post = Post.new
      render :new
    end
  end

  def edit
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:image, :description)
  end
end
