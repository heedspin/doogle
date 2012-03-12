class AddDoogleDisplayAttributes < ActiveRecord::Migration
  def up
    add_column :displays, :bonding_type_id, :integer
    add_column :displays, :backlight_color_id, :integer
    add_column :displays, :graphic_type_id, :integer
    add_column :displays, :character_rows, :float
    add_column :displays, :character_columns, :float
    add_column :displays, :luminance_nits, :integer
    add_column :displays, :twist_type_id, :integer
    add_column :displays, :filter_color_id, :integer
    add_column :displays, :display_mode_id, :integer
    add_column :displays, :viewing_width_mm, :float
    add_column :displays, :viewing_height_mm, :float
    add_column :displays, :polarizer_mode_id, :integer
    add_column :displays, :character_type_id, :integer
    add_column :displays, :active_area_width_mm, :float
    add_column :displays, :active_area_height_mm, :float
  end

  def down
  end
end