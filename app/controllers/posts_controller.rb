class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  before_action :set_post, only: [:edit, :show, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def top
    @posts = Post.limit(6).order(id: 'DESC')
  end

  def about
  end

  def index
    if params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").order(id: 'DESC').page(params[:page])
    else
      @posts = Post.order(id: 'DESC').page(params[:page])
    end
    @like = Like.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: '写真をアップロードしました。'
    else
      render :new
    end
  end

  def edit
  end

  def show
    @user = @post.user # サイドバー表示用
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿内容を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿を削除しました。'
  end

  def sort
    selection = params[:keyword]
    @posts = Post.sort(selection).page(params[:page])
  end

  def category
    @posts = Post.where(category_id: params[:id]).page(params[:page])
    @category = Category.find(params[:id])
    render :index
  end

  private

  def post_params
    params.require(:post).permit(:image, :description, :tag_list, :category_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path
    end
  end
end
