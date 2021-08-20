class AddPriorityToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :Priority, :integer, default: 0, null: false
  end
end
