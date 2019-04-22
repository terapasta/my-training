class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def new
    @task = Task.new(status: :waiting, priority: :middle)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('messages.flash.success.create')
      redirect_to tasks_path
    else
      flash.now[:error] = t('messages.flash.error.create')
      render :new
    end
  end
  
  def index
    @tasks = Task.all.default_order
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = t('messages.flash.success.update')
      redirect_to @task
    else
      flash.now[:error] = t('messages.flash.error.update')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('messages.flash.success.destroy')
      redirect_to tasks_path
    else
      flash[:error] = t('messages.flash.error.destroy')
      @tasks = Task.all
      render :index
    end
  end

  private
    def task_params
      params.require(:task).permit(:name, :description, :deadline, :status, :priority)
    end

    def set_task
      @task = Task.find_by(id: params[:id])
    end
end
