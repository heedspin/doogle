module Plutolib::Comma
  # From http://rubyforge.org/snippet/detail.php?type=snippet&id=8
  def comma(thing)
    return '' if thing.nil?
    parts = thing.to_s.split('.',2)
    result = parts[0].gsub(/(\d)(?=\d{3}+(?:\D|$))/, '\\1,')
    result += ('.' + parts[1]) if parts.size > 1
    result
  end
end
