class LabelsController < ApplicationController
  skip_before_action :require_admin

  def index
    @labels = Label.joins(:task).merge(Task.where(id: current_user.task_ids)).group(:name).count
    p @labels
    render 'index', status: '200', formats: 'json', handlers: 'jbuilder'
  end
end
