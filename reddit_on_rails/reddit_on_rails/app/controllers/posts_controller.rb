class PostsController < ApplicationController

  def show
    @post = Post.find_by(id: params[:id])
    render :show
  end

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.sub_id = params[:sub_id]

    if @post.save
      redirect_to post_url(@post.id)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    render :edit
  end

  def update
    @post = Post.find_by(id: params[:id])
    unless @post.user.id == current_user.id
      return post_url(@post)
    end

    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    unless @post.user.id == current_user.id
      return post_url(@post)
    end

    @post.destroy
    redirect_to sub_url(@post.sub_id)
  end

private

  def post_params
      params.require(:post).permit(:title, :url, :content)
  end
end
