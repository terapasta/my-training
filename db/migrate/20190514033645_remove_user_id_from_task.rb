class RemoveUserIdFromTask < ActiveRecord::Migration[5.2]
  def change
    remove_reference :tasks, :user, index: true
  end
end
