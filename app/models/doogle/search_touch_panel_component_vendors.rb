class Doogle::SearchTouchPanelComponentVendors
  def self.all
    Doogle::Display.where('displays.touch_panel_component_vendor_name is not null').where('displays.touch_panel_component_vendor_name != \'\'').select('distinct(displays.touch_panel_component_vendor_name)').order(:touch_panel_component_vendor_name).all.map { |d| [d.touch_panel_component_vendor_name, d.touch_panel_component_vendor_name] }
  end
  def self.name_like(txt)
    Doogle::Display.select('distinct(displays.touch_panel_component_vendor_name)').where(['displays.touch_panel_component_vendor_name like ?', '%' + txt + '%']).order(:touch_panel_component_vendor_name).all.map(&:touch_panel_component_vendor_name)
  end
end
