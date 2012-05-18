module DoogleHelper
  def range_select_tag(display, search_range_attribute, search_range_options)
    selected = display.send(search_range_attribute).try(:id)
    select_tag( "search[#{search_range_attribute}_id]",
                options_for_select(search_range_options, selected),
                :include_blank => true )
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
    result.try(:html_safe)
  end

  def render_field(display, field)
    value = if field.model_number?
      link_to doogle_search_excerpt(display.model_number, @search.try(:model_number)), doogle_display_url(display)
    elsif field.comment?
      doogle_search_excerpt(display.comment, @search.try(:comment))
    elsif field.integrated_controller?
      doogle_search_excerpt(display.integrated_controller, @search.try(:integrated_controller))
    elsif field.display_type?
      display.display_type.try(:name)
    elsif field.character_rows? or field.character_columns?
      doogle_cm(display.send(field.column))
    elsif field.has_many?
      display.send(field.column).map { |v| v.try(:name) }.join(', ')
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
      if display.send("#{field.column}?")
        link_to display.send("#{field.column}_file_name"), doogle_asset_path(display, field.column), {:target => '_blank'}
      else
        ''
      end
    else
      default_render_field(display, field)
    end
    value.try(:html_safe)
  end

  def default_render_field(display, field)
    val = display.send(field.value_key)
    val = if val.is_a?(Numeric)
      val = sprintf("%.1f",val) if val.is_a?(Float)
      doogle_cm(val)
    else
      val.try(:to_s)
    end
    default_render_value field, val
  end

  def default_render_value(field, val)
    if val.present?
      if field.units_short
        val = "#{val} #{field.units_short}"
      elsif field.sprintf
        val = sprintf(field.sprintf, val)
      end
    end
    val
  end

  def doogle_asset_path(display, asset)
    display_asset_path URI.escape(display.model_number, "/"), :asset => asset
  end
  
  def hosf(field)
    if (obj = @search || @display) && obj.display_type.try(:active_field?, field)
      ''
    else
      'hide'
    end
  end
end
