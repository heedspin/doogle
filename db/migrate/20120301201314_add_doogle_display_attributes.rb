class AddDoogleDisplayAttributes < ActiveRecord::Migration
  def up
    add_column :displays, :bonding_type_id, :integer
    add_column :displays, :backlight_color_id, :integer
    add_column :displays, :graphic_type_id, :integer
    add_column :displays, :character_rows, :float
    add_column :displays, :character_columns, :float
    add_column :displays, :luminance_nits, :integer
    add_column :displays, :display_mode_id, :integer
    add_column :displays, :pixel_color_id, :integer
    add_column :displays, :display_image_id, :integer
    add_column :displays, :viewing_width_mm, :float
    add_column :displays, :viewing_height_mm, :float
    add_column :displays, :polarizer_mode_id, :integer
    add_column :displays, :character_type_id, :integer
    add_column :displays, :active_area_width_mm, :float
    add_column :displays, :active_area_height_mm, :float
    add_column :displays, :backlight_type_id, :integer
    add_column :displays, :interface_id, :integer
    add_column :displays, :icon_type_id, :integer
    add_column :displays, :comments, :text
    add_column :displays, :standard_type_id, :integer
    add_column :displays, :mask_type_id, :integer
    add_column :displays, :background_color_id, :integer
    add_column :displays, :logic_operating_voltage, :float
    add_column :displays, :target_environment_id, :integer
    add_column :displays, :viewing_direction_id, :integer
    add_column :displays, :digit_height_mm, :float
  end

  def down
  end
end