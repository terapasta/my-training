class TasksController < ApplicationController
  skip_before_action :require_admin
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :show_notice_tasks, only: [:index]

  def new
    @task = Task.new(status: :waiting, priority: :middle)
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      @task.create_labels(params[:tags])
      flash[:success] = t('messages.flash.success.create', model: t('activerecord.models.task'))
      redirect_to tasks_path
    else
      flash.now[:error] = t('messages.flash.error.create', model: t('activerecord.models.task'))
      render :new
    end
  end
  
  def index
    @search_form = TaskSearchForm.new(search_params)
    tasks = @search_form.search
    @tasks = tasks.order("#{sort_column} #{sort_direction}").page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      @task.update_labels(params[:tags])
      flash[:success] = t('messages.flash.success.update', model: t('activerecord.models.task'))
      redirect_to @task
    else
      flash.now[:error] = t('messages.flash.error.update', model: t('activerecord.models.task'))
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('messages.flash.success.destroy', model: t('activerecord.models.task'))
      redirect_to tasks_path
    else
      flash[:error] = t('messages.flash.error.destroy')
      @tasks = current_user.tasks
      render :index
    end
  end

  private
    def task_params
      params.require(:task).permit(:name, :description, :deadline, :status, :priority, :group_id)
    end

    def search_params
      if params[:q]
        params.require(:q).permit(:name, :status, :priority, :group_id, label_ids:[]).merge(user_id: current_user.id)
      else
        { user_id: current_user.id }
      end
    end

    def set_task
      @task = current_user.tasks.find_by(id: params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

    def sort_column
      Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
    end

    def show_notice_tasks
      @notice_tasks = Task.get_notice_tasks(current_user)
    end
end
