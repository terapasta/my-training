class TasksController < ApplicationController
  skip_before_action :require_admin
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def new
    @task = Task.new(status: :waiting, priority: :middle)
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = t('messages.flash.success.create', model: t('activerecord.models.task'))
      redirect_to tasks_path
    else
      flash.now[:error] = t('messages.flash.error.create', model: t('activerecord.models.task'))
      render :new
    end
  end
  
  def index
    if search_params
      @search_form = TaskSearchForm.new(search_params)
      tasks = @search_form.search
    else
      tasks = current_user.tasks
    end
    @tasks = tasks.order("#{sort_column} #{sort_direction}").page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
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
      params.require(:task).permit(:name, :description, :deadline, :status, :priority)
    end

    def search_params
      params.require(:q).permit(:name, :status, :priority).merge(user_id: current_user.id) if params[:q]
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
end
