class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    # Create a new Post object 
    # The user_id column is set to the current user's id
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # Save the Post object
    if @post.save
      # Redirect to the post index page
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # Find the Post object with the given id
    @post = Post.find(params[:id])
    # Delete the Post object
    @post.destroy
    # Redirect to the post index page
    redirect_to posts_path
  end
  
  private
  def require_login
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section."
      redirect_to user_session_path
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id)
  end
end