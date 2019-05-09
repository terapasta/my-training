class TaskSearchForm
  include ActiveModel::Model

  attr_accessor :user_id, :name, :status, :priority

  def search
    rel = User.find_by(id: user_id).tasks
    rel = rel.where_like_name(self.name) if self.name.present?
    rel = rel.where_eql_status(self.status) if self.status.present?
    rel = rel.where_eql_priority(self.priority) if self.priority.present?
    rel
  end
end
