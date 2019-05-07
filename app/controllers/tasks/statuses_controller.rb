class Tasks::StatusesController < ApplicationController
  skip_before_action :require_admin

  def update
    @task = Task.find_by(id: params[:task_id])
    if @task.update(status: params[:status])
      render 'update', status: '200', formats: 'json', handlers: 'jbuilder'
    else
      render 'errors', status: '409', formats: 'json', handlers: 'jbuilder'
    end
  end
end
