class AddDoogleTftType < ActiveRecord::Migration
  def up
    add_column :displays, :tft_type_id, :integer
  end

  def down
    remove_column :displays, :tft_type_id
  end
end