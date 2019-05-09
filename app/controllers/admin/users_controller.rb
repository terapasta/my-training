class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  PER = 10

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('messages.flash.success.create', model: t('activerecord.models.user'))
      redirect_to admin_users_path
    else
      flash.now[:error] = t('messages.flash.error.create', model: t('activerecord.models.user'))
      render :new
    end
  end

  def index
    @users = User.all.order("created_at desc").page(params[:page]).per(PER)
  end

  def show
  end

  def update
    if @user.update(user_params)
      flash[:success] = t('messages.flash.success.update', model: t('activerecord.models.user'))
      redirect_to admin_user_path(@user.id)
    else
      flash.now[:error] = t('messages.flash.error.update', model: t('activerecord.models.user'))
      render :edit
    end
  end

  def destroy
    if !@user.last_admin? && @user.destroy
      flash[:success] = t('messages.flash.success.destroy', model: t('activerecord.models.user'))
      redirect_to admin_users_path
    else
      flash[:error] = t('messages.flash.error.destroy', model: t('activerecord.models.user'))
      @users = User.all.page(params[:page]).per(PER)
      render :index
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :role)
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end
end
