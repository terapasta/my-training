class GroupsController < ApplicationController
  skip_before_action :require_admin
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :set_emails, only: [:new, :create, :update, :destroy]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    user_ids = User.get_ids_by_emails(@emails_array)
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
  end

  def show
  end

  def edit
    return @emails_str = '' unless @group.users.present?
    @emails_str = @group.users.pluck(:email).join(',')
  end

  def update
    if (user_ids = User.get_ids_by_emails(@emails_array)).present? && @group.update(group_params)
      UserGroup.update_user_groups(@group, user_ids)
      flash[:success] = t('messages.flash.success.update', model: t('activerecord.models.group'))
      redirect_to @group
    else
      @emails_str = @emails_array.join(',')
      flash.now[:error] =<<-EOS
        #{t('messages.flash.error.update', model: t('activerecord.models.group'))}
        #{t('messages.flash.error.invalid', attr: t('activerecord.attributes.user.email')) if @group.errors.blank?}
      EOS
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

    def set_emails_array
      @emails_array = [ current_user.email ]
      return if params[:tags].blank?
      @emails_array.concat(params[:tags].split(',')).uniq
    end

    def set_emails_str
      @emails_str = @emails_array.join(',')
    end

    def set_emails
      set_emails_array
      set_emails_str
    end
end
