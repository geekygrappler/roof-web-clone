class ReplaceTasks < ActiveRecord::Migration
  def up
    Task.reset_all
  end
  def down

  end
end
