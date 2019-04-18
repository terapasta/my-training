class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def new
    @task = Task.new(status: :waiting, priority: :middle)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'タスクを作成しました！'
      redirect_to tasks_path
    else
      flash.now[:error] = 'タスク作成に失敗しました'
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
      flash[:success] = 'タスクを更新しました！'
      redirect_to @task
    else
      flash.now[:error] = 'タスク更新に失敗しました'
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = 'タスクを削除しました！'
      redirect_to tasks_path
    else
      flash[:error] = 'タスクを削除できませんでした'
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
