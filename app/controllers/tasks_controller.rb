class TasksController < ApplicationController
  skip_before_action :require_admin
  before_action :set_group
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_debtee, only: [:edit, :update, :destroy]
  before_action :show_notice_tasks, only: [:index]

  def new
    @task = @group.tasks.build(status: :waiting, priority: :middle)
  end

  def create
    @task = @group.tasks.build(task_params)
    if @task.create_with_user(current_user.id, task_params[:debtor_id])
      labels_array = params[:tags].split(',')
      @task.create_labels(labels_array) if labels_array.present?
      flash[:success] = t('messages.flash.success.create', model: t('activerecord.models.task'))
      redirect_to group_tasks_path(@group.id)
    else
      flash.now[:error] = t('messages.flash.error.create', model: t('activerecord.models.task'))
      render :new
    end
  end
  
  def index
    @search_form = TaskSearchForm.new(search_params)
    tasks = @search_form.search
    @tasks = tasks.order("tasks.#{sort_column} #{sort_direction}").page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      @task.update_labels(params[:tags].split(','))
      flash[:success] = t('messages.flash.success.update', model: t('activerecord.models.task'))
      redirect_to group_task_path(group_id: @group.id, id: @task.id)
    else
      flash.now[:error] = t('messages.flash.error.update', model: t('activerecord.models.task'))
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('messages.flash.success.destroy', model: t('activerecord.models.task'))
      redirect_to group_tasks_path(@group.id)
    else
      flash[:error] = t('messages.flash.error.destroy')
      @tasks = current_user.tasks
      render :index
    end
  end

  private
    def task_params
      params.require(:task).permit(:name, :description, :deadline, :status, :priority, :group_id, :debtor_id, :image)
    end

    def search_params
      if params[:q]
        params.require(:q).permit(:name, :status, :priority, :group_id, :task_role, label_ids:[]).merge(user_id: current_user.id)
      else
        { user_id: current_user.id }
      end
    end

    def set_group
      @group = current_user.groups.find_by(id: params[:group_id])
    end

    def set_task
      @task = current_user.tasks.joins(:group).find_by(id: params[:id])
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

    def require_debtee
      unless @task.user_tasks.find_by(user_id: current_user.id).debtee?
        redirect_to group_tasks_path(group_id: @group.id)
      end
    end
end
