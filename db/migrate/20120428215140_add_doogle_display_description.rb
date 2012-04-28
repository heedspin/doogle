class AddDoogleDisplayDescription < ActiveRecord::Migration
  def up
    add_column :displays, :description, :string
  end

  def down
    remove_column :displays, :description
  end
end