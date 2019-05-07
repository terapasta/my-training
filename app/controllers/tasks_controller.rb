class TasksController < ApplicationController
  skip_before_action :require_admin
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  PER = 8

  def new
    @task = Task.new(status: :waiting, priority: :middle)
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:success] = t('messages.flash.success.create', model: t('activerecord.models.task'))
      redirect_to tasks_path
    else
      flash.now[:error] = t('messages.flash.error.create', model: t('activerecord.models.task'))
      render :new
    end
  end
  
  def index
    @search_form = TaskSearchForm.new(search_params)
    @tasks = @search_form.search.order("#{sort_column} #{sort_direction}").page(params[:page]).per(PER)
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
      flash[:error] = t('messages.flash.error.destroy', model: t('activerecord.models.task'))
      @tasks = Task.all.page(params[:page]).per(PER)
      render :index
    end
  end

  private
    def task_params
      params.require(:task).permit(:name, :description, :deadline, :status, :priority, 
                                    :user_id, label_ids:[])
    end

    def search_params
      params.require(:q).permit(:name, :status, :priority) if params[:q]
    end

    def set_task
      @task = Task.find_by(id: params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

    def sort_column
      Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
    end
end
