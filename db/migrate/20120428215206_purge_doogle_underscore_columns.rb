class PurgeDoogleUnderscoreColumns < ActiveRecord::Migration
  def up
    remove_column :displays, :_number_of_digits
    remove_column :displays, :_technology_type
    remove_column :displays, :_module_dimensions
    remove_column :displays, :_digit_height
    remove_column :displays, :_polarizer_mode
    remove_column :displays, :_number_of_pins
    remove_column :displays, :_configuration
    remove_column :displays, :_lcd_type
    remove_column :displays, :_viewing_dimensions
    remove_column :displays, :_diagonal_size
    remove_column :displays, :_dot_format
    remove_column :displays, :_brightness
    remove_column :displays, :_contrast
    remove_column :displays, :_backlight_type
    remove_column :displays, :_backlight_color
    remove_column :displays, :_viewing_angle
    remove_column :displays, :_operational_temperature
    remove_column :displays, :_storage_temperature
    remove_column :displays, :_interface
    remove_column :displays, :_resolution
    remove_column :displays, :_weight
    remove_column :displays, :_power_consumption
    remove_column :displays, :_active_area
    remove_column :displays, :_outline_dimensions
    remove_column :displays, :_view_direction
    remove_column :displays, :_bonding_type
    remove_column :displays, :_pixel_configuration
    remove_column :displays, :_operating_voltage
    remove_column :displays, :_dot_size
    remove_column :displays, :_dot_pitch
    remove_column :displays, :_thickness
    remove_column :displays, :_integrated_circuit
    remove_column :displays, :_panel_size
  end

  def down
  end
end
