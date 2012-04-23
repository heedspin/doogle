class RenameDoogleDisplayType < ActiveRecord::Migration
  def change
    rename_column :displays, :type, :type_key
    rename_column :displays, :controller, :integrated_controller
    rename_column :displays, :bonding_type, :_bonding_type
    rename_column :displays, :technology_type, :_technology_type
    rename_column :displays, :backlight_color, :_backlight_color
    rename_column :displays, :polarizer_mode, :_polarizer_mode
    rename_column :displays, :backlight_type, :_backlight_type
    rename_column :displays, :interface, :_interface
    rename_column :displays, :number_of_digits, :_number_of_digits
    rename_column :displays, :module_dimensions, :_module_dimensions
    rename_column :displays, :digit_height, :_digit_height
    rename_column :displays, :number_of_pins, :_number_of_pins
    rename_column :displays, :configuration, :_configuration
    rename_column :displays, :lcd_type, :_lcd_type
    rename_column :displays, :viewing_dimensions, :_viewing_dimensions
    rename_column :displays, :diagonal_size, :_diagonal_size
    rename_column :displays, :dot_format, :_dot_format
    rename_column :displays, :brightness, :_brightness
    rename_column :displays, :contrast, :_contrast
    rename_column :displays, :viewing_angle, :_viewing_angle
    rename_column :displays, :operational_temperature, :_operational_temperature
    rename_column :displays, :storage_temperature, :_storage_temperature
    rename_column :displays, :resolution, :_resolution
    rename_column :displays, :weight, :_weight
    rename_column :displays, :power_consumption, :_power_consumption
    rename_column :displays, :active_area, :_active_area
    rename_column :displays, :outline_dimensions, :_outline_dimensions
    rename_column :displays, :view_direction, :_view_direction
    rename_column :displays, :pixel_configuration, :_pixel_configuration
    rename_column :displays, :operating_voltage, :_operating_voltage
    rename_column :displays, :dot_size, :_dot_size
    rename_column :displays, :dot_pitch, :_dot_pitch
    rename_column :displays, :thickness, :_thickness
    rename_column :displays, :integrated_circuit, :_integrated_circuit
    rename_column :displays, :panel_size, :_panel_size
    add_column :displays, :viewing_cone, :integer
  end

end