class Doogle::ModuleWidthRange < Doogle::ActiveRange
  self.data = [
    { :id => 1, :max => 25 },
    { :id => 2, :min => 25, :max => 100 },
    { :id => 3, :min => 100, :max => 200 },
    { :id => 4, :min => 200 },
  ]
  
  def units_short
    'mm'
  end
end

