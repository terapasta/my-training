class TaskSearchForm
  include ActiveModel::Model

  attr_accessor :user_id, :name, :status, :priority, :label_ids, :group_id

  def search
    rel = User.includes(tasks: :labels).find_by(id: user_id).tasks.joins(:group)
    rel = rel.where_like_name(self.name) if self.name.present?
    rel = rel.where_eql_status(self.status) if self.status.present?
    rel = rel.where_eql_priority(self.priority) if self.priority.present?
    rel = rel.where_eql_label_ids(self.label_ids) if self.label_ids.present?
    rel = rel.where_eql_group_id(self.group_id) if self.group_id.present?
    rel
  end
end
