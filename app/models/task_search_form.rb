class TaskSearchForm
  include ActiveModel::Model

  attr_accessor :name, :status

  def search
    rel = Task.all
    rel = rel.where_like_name(self.name) if self.name
    rel = rel.where_eql_status(self.status) if self.status
    rel
  end
end
