class Doogle::ModuleDiagonalRange < Doogle::ActiveRange
  self.data = [
    { :id => 1, :max => 3 },
    { :id => 2, :min => 3, :max => 5 },
    { :id => 3, :min => 5, :max => 10 },
    { :id => 4, :min => 10 },
  ]
  
  def units_short
    'in'
  end
end

