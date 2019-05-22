class UsersController < ApplicationController
  skip_before_action :require_admin
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = t('messages.flash.success.update', model: t('activerecord.models.user'))
      redirect_to users_mypage_path
    else
      flash.now[:error] = t('messages.flash.error.update', model: t('activerecord.models.user'))
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :image)
    end

    def set_user
      @user = current_user
    end
end
