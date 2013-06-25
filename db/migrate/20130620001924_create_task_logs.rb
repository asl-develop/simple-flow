class CreateTaskLogs < ActiveRecord::Migration
  def change
    create_table :task_logs do |t|
      t.references :user
      t.references :task
      t.integer :action

      t.timestamps
    end
    add_index :task_logs, :user_id
    add_index :task_logs, :task_id
  end
end
