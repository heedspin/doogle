class Doogle::DisplayPartition
  attr_accessor :heading, :displays, :hide_fields
  def initialize(args)
    @heading = args[:heading]
    @displays = args[:displays]
    @hide_fields = args[:hide_fields] || []
  end
  
  def web_list_fields
    return [] unless self.display_type.try(:web_list_fields)
    self.display_type.web_list_fields.select { |f| !self.hide_fields.include?(f.key) }
  end
  
  def display_type
    @displays.first.try(:display_type)
  end
end