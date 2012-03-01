class Doogle::StorageTemperatureMinRange < ActiveHash::Base
  self.data = [
    {:id => 1, :min => 10},
    {:id => 2, :min => 20},
    {:id => 3, :min => 25},
    {:id => 4, :min => 30},
    {:id => 5, :min => 40},
  ]
  
  def name
    "#{self.min}&deg;C".html_safe
  end
end