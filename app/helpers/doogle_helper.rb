module DoogleHelper
  def range_select_tag(display, field)
    selected = display.send(field.search_range_attribute).try(:id)
    select_tag "search[#{field.search_range_attribute}_id]", options_for_select(field.search_range_options, selected), :include_blank => true
  end
  
  def field_td_class(display, field)
    'centered'
  end
  
  def doogle_cm(thing, nil_if_equals=nil)
    if thing and (thing.to_f != nil_if_equals)
      if (thing.is_a?(Float) or thing.is_a?(BigDecimal)) and (thing.to_i == thing)
        thing = sprintf('%0.f', thing)
      end
      comma(thing)
    else
      nil
    end
  end
  
  def doogle_search_excerpt(txt, search_txt)
    result = if txt.present? and search_txt.present? 
      txt.gsub(/(#{search_txt})/i).each do |token|
        '<span class="search_match">' + $1 + '</span>'
      end
    else
      txt
    end
    result.html_safe
  end
  
  def render_field(display, field)
    value = if field.model_number?
      link_to doogle_search_excerpt(display.model_number, @search.try(:model_number)), doogle_display_url(display)
    elsif field.comment?
      doogle_search_excerpt(display.comment, @search.try(:comment))
    elsif field.integrated_controller?
      doogle_search_excerpt(display.integrated_controller, @search.try(:integrated_controller))
    elsif field.display_type?
      display.display_type.name
    elsif field.character_rows? or field.character_columns?
      doogle_cm(display.send(field.key))
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
    elsif field.attachment?
      if display.send("#{field.key}?")
        link_to display.send("#{field.key}_file_name"), doogle_asset_path(display, field.key)
      else
        ''
      end
    else
      default_render_field(display, field)
    end
		value.try(:html_safe)
	end
	
	def default_render_field(display, field)
	  val = display.send(field.key)
    val = if val.is_a?(Numeric)
      val = sprintf("%.1f",val) if val.is_a?(Float)
      doogle_cm(val)
    else
      val.try(:to_s)
    end
    default_render_value field, val
    val
  end
  
  def default_render_value(field, val)
    if field.units_short and val.present?
      val = "#{val} #{field.units_short}"
    end
    val
  end
  
  def doogle_asset_path(display, asset)
    display_asset_path URI.escape(display.model_number, "/"), :asset => asset
  end
end
