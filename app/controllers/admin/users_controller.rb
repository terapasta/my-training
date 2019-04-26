class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  PER = 10

  def new
    @user = User.new
  end

  def create
  end

  def index
    @users = User.all.page(params[:page]).per(PER)
  end

  def show
  end

  def update
  end

  def destroy
    if @user.destroy
      flash[:success] = t('messages.flash.success.destroy')
      redirect_to admin_users_path
    else
      flash[:error] = t('messages.flash.error.destroy')
      @users = User.all
      render :index
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end
end
