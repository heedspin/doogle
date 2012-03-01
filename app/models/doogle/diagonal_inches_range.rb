class Doogle::DiagonalInchesRange < ActiveHash::Base
  self.data = [
    {:id => 1, :min => 0.0, :max => 3.0 },
    {:id => 2, :min => 3.0, :max => 6.0 },
    {:id => 3, :min => 6.0, :max => 9.0 },
    {:id => 4, :min => 9.0 },
  ]
  
  def exact?
    self.min.nil?
  end
  
  def exact
    self.max
  end
  
  def no_max?
    self.max.nil?
  end
  
  def name
    if self.exact?
      "#{self.exact}\""
    elsif self.no_max?
      '> ' + sprintf("%.1f",self.min) + '"'
    else
      sprintf("%.1f",self.min) + '" to ' +  sprintf("%.1f",self.max) + '"'
    end
  end
end

