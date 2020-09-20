class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]

  def top
    @posts = Post.limit(6).order(id: 'DESC')
  end

  def about
  end

  def index
    if params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").order(id: 'DESC').page(params[:page]).per(9)
      @like = Like.new
    else
      @posts = Post.all.order(id: 'DESC').page(params[:page]).per(9)
      @like = Like.new
    end
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
    @post = Post.find(params[:id])
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user #サイドバー表示用
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿内容を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: '投稿を削除しました。'
  end

  def sort
    selection = params[:keyword]
    @posts = Post.sort(selection).page(params[:page]).per(9)
  end

  def category
    @posts = Post.where(category_id: params[:id]).page(params[:page]).per(9)
    @category = Category.find(params[:id])
    render :index
  end

  private

  def post_params
    params.require(:post).permit(:image, :description, :tag_list, :category_id)
  end
end
