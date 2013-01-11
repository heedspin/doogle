require 'doogle/formatting'

module DoogleHelper
  include Doogle::Formatting
  
  def range_select_tag(display, search_range_attribute, search_range_options)
    selected = display.send(search_range_attribute).try(:id)
    select_tag( "search[#{search_range_attribute}_id]",
                options_for_select(search_range_options, selected),
                :include_blank => true )
  end

  def hosf(field)
    if (obj = @search || @display) && obj.display_type.try(:active_field?, field)
      ''
    else
      'hide'
    end
  end

  def ssf(field)
    (@show_search_fields.nil? or @show_search_fields.include?(field)) ? '' : 'hide'
  end

  def field_class(field, display=nil)
    hide = 'hide ' unless (@show_results_fields.nil? || @show_results_fields.include?(field))
    "#{hide}#{field.key}_cell"
  end

  def partition_displays(displays)
    result = []
    if displays
      if :tft_displays == displays.first.try(:display_type).try(:key)
        sunlight, tft = displays.partition { |d| d.target_environment.try(:sunlight_readable?) }
        result.push Doogle::DisplayPartition.new( :heading => 'Sunlight Readable TFTs',
                                                  :displays => sunlight,
                                                  :hide_fields => [:operational_temperature, :storage_temperature] )
        result.push Doogle::DisplayPartition.new( :heading => 'Digital TFTs',
                                                  :displays => tft,
                                                  :hide_fields => [:luminance_nits] )
      else
        result.push Doogle::DisplayPartition.new( :heading => displays.first.try(:display_type).try(:web_name),
                                                  :displays => displays )
      end
    end
    result
  end

  def doogle_variable_time(time, today_format=:just_time, past_format=:number_date)
    return nil unless time
    now = Time.current
    today = (time.day == now.day) && (time.year == now.year)
    time.to_s(today ? today_format : past_format)
  end
end
