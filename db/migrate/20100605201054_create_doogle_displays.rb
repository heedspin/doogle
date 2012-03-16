class CreateDoogleDisplays < ActiveRecord::Migration
  def self.up
    create_table :displays, :force => true do |t|
      t.string   "type"
      t.string   "model_number"
      t.string   "number_of_digits"
      t.string   "technology_type"
      t.string   "module_dimensions"
      t.string   "digit_height"
      t.string   "polarizer_mode"
      t.string   "number_of_pins"
      t.string   "configuration"
      t.string   "lcd_type"
      t.string   "viewing_dimensions"
      t.string   "diagonal_size"
      t.string   "dot_format"
      t.string   "brightness"
      t.string   "contrast"
      t.string   "backlight_type"
      t.string   "backlight_color"
      t.string   "viewing_angle"
      t.string   "operational_temperature"
      t.string   "storage_temperature"
      t.string   "interface"
      t.string   "resolution"
      t.string   "weight"
      t.string   "power_consumption"
      t.string   "active_area"
      t.string   "outline_dimensions"
      t.string   "view_direction"
      t.string   "bonding_type"
      t.string   "pixel_configuration"
      t.string   "controller"
      t.string   "operating_voltage"
      t.integer  "status_id"
      t.integer  "creator_id"
      t.integer  "updater_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "position"
      t.string   "colors"
      t.string   "dot_size"
      t.string   "dot_pitch"
      t.string   "thickness"
      t.string   "integrated_circuit"
      t.string   "panel_size"
      t.integer  "source_id"
      t.string   "source_model_number"
      t.string   "datasheet_file_name"
      t.string   "datasheet_content_type"
      t.integer  "datasheet_file_size"
      t.datetime "datasheet_updated_at"
      t.integer  "touch_panel_type_id"
      t.integer  "timing_controller_type_id"
      t.integer  "specification_type_id"
    end
  end

  def self.down
    drop_table :displays
  end
end
