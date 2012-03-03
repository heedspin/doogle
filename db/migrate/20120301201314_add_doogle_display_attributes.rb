class AddDoogleDisplayAttributes < ActiveRecord::Migration
  def up
    add_column :displays, :bonding_type_id, :integer
    add_column :displays, :backlight_color_id, :integer
    add_column :displays, :graphic_type_id, :integer
    add_column :displays, :character_rows, :integer
    add_column :displays, :character_columns, :integer
    add_column :displays, :luminance_nits, :integer
  end

  def down
  end
end