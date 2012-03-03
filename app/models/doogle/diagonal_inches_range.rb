class Doogle::DiagonalInchesRange < Doogle::ActiveRange
  self.data = [
    {:id => 1, :max => 3.0 },
    {:id => 2, :min => 3.0, :max => 6.0 },
    {:id => 3, :min => 6.0, :max => 9.0 },
    {:id => 4, :min => 9.0 },
  ]
  
  def value_to_s(value)
    sprintf("%.1f",value) + '"'
  end
end

