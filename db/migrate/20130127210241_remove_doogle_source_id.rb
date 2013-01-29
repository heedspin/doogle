class RemoveDoogleSourceId < ActiveRecord::Migration
  def up
    remove_column :displays, :source_id
  end

  def down
    add_column :displays, :source_id, :integer
  end
end
