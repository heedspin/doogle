module DoogleHelper
  def range_select_tag(display, field)
    selected = display.send(field.search_range_attribute).try(:id)
    select_tag "search[#{field.search_range_attribute}_id]", options_for_select(field.search_range_options, selected), :include_blank => true
  end
  
  def field_td_class(display, field)
    'centered'
  end
  
  def render_field(display, field)
    value = if field.model_number?
      link_to search_excerpt(display.model_number, @search.try(:model_number)), doogle_display_url(display)
    elsif field.comment?
      search_excerpt(display.comment, @search.try(:comment))
    elsif field.integrated_controller?
      search_excerpt(display.integrated_controller, @search.try(:integrated_controller))
    elsif field.display_type?
      display.display_type.name
    elsif field.character_rows? or field.character_columns?
      cm(display.send(field.key),:trim_decimals)
    elsif field.has_many?
      display.send(field.key).map(&:name).join(', ')
    elsif field.dimension?
      dimension_values = []
      field.dimensions.each do |child_field|
        child_value = render_field(display, child_field)
        break unless child_value.present?
        dimension_values.push child_value
      end
      dimension_joiner = field.key.to_s.include?('temperature') ? ' to ' : ' x '
      default_render_value field, dimension_values.join(dimension_joiner)
    else
      default_render_field(display, field)
    end
		value.try(:html_safe)
	end
	
	def default_render_field(display, field)
	  val = display.send(field.key)
    val = if val.is_a?(Numeric)
      val = sprintf("%.1f",val) if val.is_a?(Float)
      cm(val)
    else
      val.try(:to_s)
    end
    default_render_value field, val
    val
  end
  
  def default_render_value(field, val)
    if field.units_short
      val = "#{val} #{field.units_short}"
    end
    val
  end
end
