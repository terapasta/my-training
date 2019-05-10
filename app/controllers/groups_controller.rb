class GroupsController < ApplicationController
  skip_before_action :require_admin
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      # TODO: トランザクション使ったほうがよい？
      UserGroup.create(user_id: current_user.id, group_id: @group.id)
      flash[:success] = t('messages.flash.success.create', model: t('activerecord.models.group'))
      redirect_to groups_path
    else
      flash.now[:error] = t('messages.flash.error.create', model: t('activerecord.models.group'))
      render :new
    end
  end

  def index
    @groups = current_user.groups.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @group.update(group_params)
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
end
