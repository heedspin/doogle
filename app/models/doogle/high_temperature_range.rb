class Doogle::HighTemperatureRange < Doogle::ActiveRange
  self.data = [
    {:id => 1, :max => 70},
    {:id => 2, :min => 70, :max => 90},
    {:id => 3, :min => 90}
  ]

  def units_short
    '&deg;C'
  end
end
