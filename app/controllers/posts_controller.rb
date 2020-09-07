class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]

  def top
    @posts = Post.limit(8).order(id: 'DESC')
  end

  def about
  end

  def index
    @posts = Post.all.order(id: 'DESC').page(params[:page]).per(8)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: '写真を投稿しました'
    else
      @post = Post.new
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def show
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:image, :description)
  end
end
