class SubsController < ApplicationController
  before_action :require_login



  belongs_to :moderator
  primary_key: :id,
  foreign_key: :moderator_id,
  class_name: :User

  has_many :posts,
  dependent: :destroy

  def index
    @subs = Sub.all
  end

  def show
    @sub = find_by(id: params[:id])
    render :show
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(user_params)
    @sub.moderator_id = current_user.id

    if sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end

  end


  def edit
    @sub = Sub.find_by(id: params[:id])
    render :edit
  end

  def update
    @sub = Sub.find_by(id: params[:id])

    unless @sub.moderator.id == current_user.id
      redirect_to subs_url(@sub)
      return
    end

    if @sub.update(sub_params)
      redirect_to subs_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end

  end

  def destroy
    @sub = Sub.find_by(id: params[:id])

    unless @sub.moderator == current_user
      redirect_to subs_url(@sub)
      return
    end

    @sub.destroy
    redirect_to subs_url
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
