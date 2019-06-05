class Api::UsersController < ApplicationController
  skip_before_action :require_admin
  before_action :set_group, only: [:index]

  def index
    p 'ああああ」'
    p @group
    @users = @group.users.where.not(id: current_user.id)
    render 'index', status: '200', formats: 'json', handlers: 'jbuilder'
  end

  private
    def set_group
      p '呼ばれたよん'
      p "params: #{params}"
      p "group_id: #{params[:group_id]}"
      p current_user
      p current_user.groups
      p current_user.groups.find_by(id: params[:group_id])
      @group = current_user.groups.find_by(id: params[:group_id])
    end
end
