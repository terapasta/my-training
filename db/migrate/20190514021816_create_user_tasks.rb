class CreateUserTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tasks do |t|
      t.references :user, foreign_key: true
      t.references :task, foreign_key: true
      t.integer :task_status
      t.integer :priority
      t.integer :task_role
      t.date :scheduled_date

      t.timestamps
    end
  end
end
