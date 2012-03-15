module DoogleHelper
  def range_select_tag(display, field)
    selected = display.send(field.search_range_attribute).try(:id)
    select_tag "search[#{field.search_range_attribute}_id]", options_for_select(field.search_range_options, selected), :include_blank => true
  end
  
  def field_td_class(display, field)
    'centered'
  end
  
  def render_field(display, field)
    value = if field.dimension?
      dimension_values = []
      field.dimensions.each do |child_field|
        child_value = render_field(display, child_field)
        break unless child_value.present?
        dimension_values.push child_value
      end
      dimension_values.join(' x ')
    elsif field.model_number?
      link_to search_excerpt(display.model_number, @search.model_number), display_url(display)
    elsif field.controller?
      search_excerpt(display.controller, @search.controller)
    elsif field.type?
      display.display_config.name
    elsif field.character_rows? or field.character_columns?
      cm(display.send(field.key),:trim_decimals)
    else
      val = display.send(field.key)
      if val.is_a?(Numeric)
        val = sprintf("%.1f",val) if val.is_a?(Float)
        cm(val)
      else
        val.try(:to_s)
      end
    end
		value.try(:html_safe)
	end
end
