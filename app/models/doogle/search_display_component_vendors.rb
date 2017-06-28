class Doogle::SearchDisplayComponentVendors
  def self.all
    Doogle::Display.where('displays.display_component_vendor_name is not null').where('displays.display_component_vendor_name != \'\'').select('distinct(displays.display_component_vendor_name)').order(:display_component_vendor_name).all.map { |d| [d.display_component_vendor_name, d.display_component_vendor_name] }
  end
  def self.name_like(txt)
    Doogle::Display.select('distinct(displays.display_component_vendor_name)').where(['displays.display_component_vendor_name ilike ?', '%' + txt + '%']).order(:display_component_vendor_name).all.map(&:display_component_vendor_name)
  end
end
