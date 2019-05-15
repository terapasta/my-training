class AddReferenceGroupToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :group, index: true
  end
end
