class Doogle::ActiveRange < ActiveHash::Base
  def exact?
    self.min == self.max
  end
  
  def exact
    self.max
  end
  
  def no_max?
    self.max.nil?
  end
  
  def no_min?
    self.min.nil?
  end
  
  def value_to_s(value)
    value.to_s
  end
  
  def name
    if self.exact?
     value_to_s(self.exact) 
    elsif self.no_min?
      '< ' + value_to_s(self.max)
    elsif self.no_max?
      '> ' + value_to_s(self.min)
    else
      value_to_s(min) + ' to ' +  value_to_s(max)
    end.html_safe
  end
  
  def self.find_by_name(name)
    self.all.detect { |v| v.name == name }
  end
end

