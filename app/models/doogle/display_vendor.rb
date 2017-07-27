class Doogle::DisplayVendor
  attr_accessor :m2m_vendor, :vendor_name, :short_name, :vendor_part_number, :last_date, :preferred_vendor
  def initialize(display_price)
    @m2m_vendor = display_price.m2m_vendor
    @vendor_name = display_price.vendor_name
    @vendor_part_number = display_price.vendor_part_number
    @short_name = AppConfig.vendor_short_names[display_price.m2m_vendor_id.to_i] || @vendor_name
    @last_date = display_price.last_date || Date.current.end_of_year
    @preferred_vendor = display_price.preferred_vendor
  end  
end