class Api::TasksController < ApplicationController
  skip_before_action :require_admin

  def index
    @tasks = current_user.tasks
    render 'index', status: '200', formats: 'json', handlers: 'jbuilder'
  end
end
