class Tasks::ReadDatestampsController < ApplicationController
  skip_before_action :require_admin

  def update
    @task = current_user.tasks.find_by(id: params[:task_id])
    if @task.update(read_datestamp: Time.zone.today)
      render 'update', status: '200', formats: 'json', handlers: 'jbuilder'
    else
      render 'errors', status: '409', formats: 'json', handlers: 'jbuilder'
    end
  end
end
