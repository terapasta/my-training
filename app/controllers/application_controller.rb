class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :require_login
  before_action :require_admin
  helper_method [:login?, :current_user, :is_debtee?]

  def login(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def logout
    forget(current_user)
    session[:user_id] = nil
    @current_user  = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login(user)
        @current_user = user
      end
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

  def require_admin
    unless login? && @current_user.admin?
      render_404
    end
  end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end

  private
    def is_debtee?(user, task_id)
      user.user_tasks.find_by(task_id: task_id).task_role == 'debtee'
    end
end
