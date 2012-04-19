class ChangeDoogleFloatsToDecimals < ActiveRecord::Migration
  def change
    change_column :displays, :module_width_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :module_height_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :module_thickness_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :module_diagonal_in, :decimal, :precision => 12, :scale => 4
    change_column :displays, :character_rows, :decimal, :precision => 12, :scale => 4
    change_column :displays, :character_columns, :decimal, :precision => 12, :scale => 4
    change_column :displays, :viewing_width_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :viewing_height_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :active_area_width_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :active_area_height_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :logic_operating_voltage, :decimal, :precision => 12, :scale => 4
    change_column :displays, :digit_height_mm, :decimal, :precision => 12, :scale => 4
    change_column :displays, :total_power_consumption, :decimal, :precision => 12, :scale => 4
  end
end
