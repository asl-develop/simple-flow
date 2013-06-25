class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :content
      t.integer :charge_user_id
      t.integer :state
      t.integer :locked, :default => 0
      t.string :flow
      t.integer :author_id

      t.timestamps
    end
  end
end
