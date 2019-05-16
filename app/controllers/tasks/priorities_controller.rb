class Tasks::PrioritiesController < ApplicationController
  skip_before_action :require_admin

  def update
    @task = Task.find_by(id: params[:task_id])
    if is_debtee?(current_user, @task.id) && @task.update(priority: params[:priority])
      render 'update', status: '200', formats: 'json', handlers: 'jbuilder'
    else
      render 'errors', status: '409', formats: 'json', handlers: 'jbuilder'
    end
  end
end
