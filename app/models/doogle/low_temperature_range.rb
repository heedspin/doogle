class Doogle::LowTemperatureRange < Doogle::ActiveRange
  self.data = [
    {:id => 1, :max => 20},
    {:id => 2, :min => 20, :max => 25},
    {:id => 3, :min => 25, :max => 30},
    {:id => 4, :min => 30, :max => 40},
    {:id => 5, :min => 40},
  ]

  def units_short
    '&deg;C'
  end
end
