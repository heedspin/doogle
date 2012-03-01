class Doogle::ResolutionXRange < ActiveHash::Base
  self.data = [
    {:id => 1, :min => 1, :max => 128 },
    {:id => 2, :min => 128},
    {:id => 3, :min => 128, :max => 256},
    {:id => 4, :min => 256, :max => 512},
    {:id => 5, :min => 512, :max => 1024},
    {:id => 6, :min => 800},
    {:id => 7, :min => 1024, :max => 1440},
  ]
  
  def exact?
    self.max.nil?
  end
  
  def exact
    self.min
  end
  
  def name
    if self.exact?
      self.exact
    else
      "#{self.min} to #{self.max}"
    end
  end
end

