class AddReadDate < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :read_datestamp, :date
  end
end
