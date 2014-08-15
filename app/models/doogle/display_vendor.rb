class Doogle::DisplayVendor
  
  SHORT_NAMES = {
    '000352' => 'Innolux',
    '000258' => 'MIT',
    '000173' => 'RIT',
    '000336' => 'ETD',
    '000139' => 'NT',
    '000088' => 'Jiya',
    '000104' => 'Jiya LF',
    '000139' => 'Nely',
    '000346' => 'Wise',
    '000161' => 'Prime',
    '000365' => 'YJE',
    '000389' => 'URT',
    '000014' => 'Ampire',
    '000304' => 'Winsonic',
    '000412' => 'DI'
  }
  
  attr_accessor :m2m_vendor, :vendor_name, :short_name, :vendor_part_number, :last_date, :preferred_vendor
  def initialize(display_price)
    @m2m_vendor = display_price.m2m_vendor
    @vendor_name = display_price.vendor_name
    @vendor_part_number = display_price.vendor_part_number
    @short_name = SHORT_NAMES[display_price.m2m_vendor_id] || @vendor_name
    @last_date = display_price.last_date || Date.current.end_of_year
    @preferred_vendor = display_price.preferred_vendor
  end  
  
  def self.id_for_short_name(txt)
    @id_for_short_name ||= SHORT_NAMES.invert
    @id_for_short_name[txt] || (raise "No vendor for #{txt}")
  end
end