class AddDoogleComponents < ActiveRecord::Migration
  def up
    add_column :displays, :display_component_vendor_name, :string
    add_column :displays, :display_component_model_number, :string
    # add_column :displays, :display_component_display_id, :integer
    add_column :displays, :touch_panel_component_vendor_name, :string
    add_column :displays, :touch_panel_component_model_number, :string
    # add_column :displays, :touch_panel_component_display_id, :integer
  end

  def down
    # remove_column :displays, :touch_panel_component_display_id
    remove_column :displays, :touch_panel_component_model_number
    remove_column :displays, :touch_panel_component_vendor_name
    # remove_column :displays, :display_component_display_id
    remove_column :displays, :display_component_model_number
    remove_column :displays, :display_component_vendor_name
  end
end