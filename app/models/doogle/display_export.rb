require 'plutolib/xls_report'

class Doogle::DisplayExport
  include Plutolib::XlsReport
  
  def initialize(search, displays)
    @search = search
    @displays = displays
  end
  
  def filename
    'doogle_displays'
  end
  
  def sheet_name
    'Displays'
  end
  
  def initialize_fields
    result_fields = @search.display_type.present? ? @search.display_type.fields : Doogle::FieldConfig.top_level
    result_fields = result_fields.select { |f| ![:datasheet, :specification, :source_specification].include?(f.key) }
    result_fields.each do |field|
      self.fields.push M2mhub::XlsReport::Field.new(field.name) { |d| field.render(d, :search => @search, :format => :xls) }
    end
  end
  
  def all_data
    @displays
  end
end
