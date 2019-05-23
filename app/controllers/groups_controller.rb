class GroupsController < ApplicationController
  skip_before_action :require_admin
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :set_emails, only: [:edit, :create, :update, :destroy]

  def new
    @group = Group.new
    @emails = [ current_user.email ]
  end

  def create
    @group = Group.new(group_params)
    user_ids = User.get_ids_by_emails(@emails)
    if user_ids.blank?
      flash.now[:error] = t('messages.flash.error.invalid', attr: t('activerecord.attributes.user.email'))
      return render :new
    end
    if @group.save
      UserGroup.create_user_groups(@group, user_ids)
      flash[:success] = t('messages.flash.success.create', model: t('activerecord.models.group'))
      redirect_to groups_path
    else
      flash.now[:error] = t('messages.flash.error.create', model: t('activerecord.models.group'))
      render :new
    end
  end

  def index
    @groups = current_user.groups.page(params[:page])
    @tasks = current_user.tasks.includes(:group).merge(UserTask.where(task_role: 'debtor'))
  end

  def show
  end

  def edit
  end

  def update
    user_ids = User.get_ids_by_emails(@emails)
    if user_ids.blank?
      t('messages.flash.error.invalid', attr: t('activerecord.attributes.user.email')) if @group.errors.blank?
      return render :edit
    end
    if @group.update(group_params)
      UserGroup.update_user_groups(@group, user_ids)
      flash[:success] = t('messages.flash.success.update', model: t('activerecord.models.group'))
      redirect_to @group
    else
      flash.now[:error] = t('messages.flash.error.update', model: t('activerecord.models.group'))
      render :edit
    end
  end

  def destroy
    if @group.destroy
      flash[:success] = t('messages.flash.success.destroy', model: t('activerecord.models.group'))
      redirect_to groups_path
    else
      flash[:error] = t('messages.flash.error.destroy')
      @groups = current_user.groups
      render :index
    end
  end

  private
    def group_params
      params.require(:group).permit(:name)
    end

    def set_group
      @group = current_user.groups.find_by(id: params[:id])
    end

    def set_emails
      if params[:tags].blank?
        @emails = @group.users.pluck(:email)
      else
        @emails = [ current_user.email ].concat(params[:tags].split(',')).uniq
      end
    end

end
