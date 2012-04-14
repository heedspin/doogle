class Doogle::FieldOfViewRange < Doogle::ActiveRange
  self.data = [
    {:id => 1, :max => 90},
    {:id => 2, :min => 90, :max => 135},
    {:id => 3, :min => 135, :max => 180},
  ]

  def units_short
    '&deg;'
  end
end
