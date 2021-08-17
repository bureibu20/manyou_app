class ChangeColumnNullTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :title, false
    change_column_null :tasks, :content, false
    change_column_null :tasks, :expired_at, false 
  end
end
