require 'plutolib/comma'

module Doogle::Formatting
  include Plutolib::Comma
  
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
end