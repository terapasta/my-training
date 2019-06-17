class Api::TasksController < ApplicationController
  skip_before_action :require_admin
  before_action :set_group, only: [:create, :update]

  def create
    @task = @group.tasks.build(task_params)
    if @task.create_with_user(current_user.id, task_params[:debtor_id])
      if params[:task][:labels].present?
        labels_array = params[:task][:labels].split(',')
        @task.create_labels(labels_array)
      end
      render 'create', status: '201', formats: 'json', handler: 'jbuilder'
    else
      render 'errors', status: '409', formats: 'json', handler: 'jbuilder'
    end
  end

  def index
    @tasks = current_user.tasks.includes(:group, :labels).order("created_at desc")
    render 'index', status: '200', formats: 'json', handlers: 'jbuilder'
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      render 'update', status: '204', formats: 'json', handers: 'jbuilder'
    else
      render 'errors', status: '409', formats: 'json', handers: 'jbuilder'
    end
  end

  private
    def task_params
      params.require(:task).permit(:id, :name, :description, :deadline, :status, :priority, 
        :group_id, :debtor_id, :labels, :image, :amount).merge(group_id: @group.id)
    end
    
    def set_group
      @group = current_user.groups.find_by(id: params[:task][:group_id])
    end
end
