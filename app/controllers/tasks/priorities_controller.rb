class Tasks::PrioritiesController < ApplicationController

  def update
    @task = Task.find_by(id: params[:task_id])
    if @task.update(priority: params[:priority])
      render 'update', status: '200', formats: 'json', handlers: 'jbuilder'
    else
      render 'errors', status: '422', formats: 'json', handlers: 'jbuilder'
    end
  end
end
