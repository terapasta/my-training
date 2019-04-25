class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :require_login
  helper_method [:login?, :current_user]

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
    @current_user  = nil
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def login?
    @current_user.present?
  end

  def require_login
    unless login?
      flash[:info] = t('messages.flash.info.login')
      redirect_to login_path
    end
  end
end
