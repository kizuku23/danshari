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
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
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

 def sort
    selection = params[:keyword]
    @posts = Post.sort(selection).page(params[:page]).per(9)
 end

  private

  def post_params
    params.require(:post).permit(:image, :description, :tag_list)
  end
end
