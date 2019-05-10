class GroupsController < ApplicationController
  skip_before_action :require_admin

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
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def group_params
      params.require(:group).permit(:name)
    end
end
