class AddDoogleDisplayAttributes < ActiveRecord::Migration
  def change
    add_column :displays, :resolution_x, :integer
    add_column :displays, :resolution_y, :integer
    add_column :displays, :storage_temperature_min, :integer
    add_column :displays, :storage_temperature_max, :integer
    add_column :displays, :operational_temperature_min, :integer
    add_column :displays, :operational_temperature_max, :integer
    add_column :displays, :module_width_mm, :float
    add_column :displays, :module_height_mm, :float
    add_column :displays, :module_thickness_mm, :float
    add_column :displays, :module_diagonal_in, :float
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
    add_column :displays, :standard_classification_id, :integer
    add_column :displays, :mask_type_id, :integer
    add_column :displays, :background_color_id, :integer
    add_column :displays, :logic_operating_voltage, :float
    add_column :displays, :target_environment_id, :integer
    add_column :displays, :viewing_direction_id, :integer
    add_column :displays, :digit_height_mm, :float
    add_column :displays, :total_power_consumption, :float
    add_column :displays, :no_of_pins, :integer
    add_column :displays, :contrast_ratio, :integer
    add_column :displays, :field_of_view, :integer
    add_column :displays, :current_revision, :boolean
    add_column :displays, :revision, :string
    add_column :displays, :approval_status_id, :integer
    add_column :displays, :publish_to_erp, :boolean
    add_column :displays, :erp_id, :integer
    add_column :displays, :publish_to_web, :boolean
    add_column :displays, :needs_pushed_to_web, :boolean
  end
end