class Doogle::PowerConsumptionRange < Doogle::ActiveRange
  self.data = [
    { :id => 1, :max => 0.3 },
    { :id => 2, :min => 0.3, :max => 1.0 },
    { :id => 3, :min => 1.0 },
  ]

  def units_short
    'W'
  end
end


