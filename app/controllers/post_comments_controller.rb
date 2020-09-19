class PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id
    if @post_comment.save
      render :index
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.find_by(id: params[:id], post_id: @post.id)
    @post_comment.destroy
    render :index
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
