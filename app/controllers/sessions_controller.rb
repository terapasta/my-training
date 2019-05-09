class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:create]

  def new
  end

  def create
    if @user && @user.authenticate(session_params[:password])
      login(@user)
      flash[:success] = t('messages.flash.success.login')
      redirect_to root_path
    else
      flash.now[:error] = t('messages.flash.error.login')
      render :new
    end
  end

  def destroy
    logout
    flash[:success] = t('messages.flash.success.logout')
    redirect_to login_path
  end

  private
    def set_user
      @user = User.find_by(email: session_params[:email])
    end

    def session_params
      params.require(:session).permit(:email, :password)
    end
end
