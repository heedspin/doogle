class AddDoogleDisplayOnMasterList < ActiveRecord::Migration
  def up
    add_column :displays, :on_master_list, :boolean 
  end

  def self.down
    remove_column :displays, :on_master_list
  end
end