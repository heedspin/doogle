class Doogle::ModuleThicknessRange < Doogle::ActiveRange
  self.data = [
    { :id => 1, :max => 5 },
    { :id => 2, :min => 5, :max => 10 },
    { :id => 3, :min => 10 },
  ]
  
  def value_to_s(value)
    "#{value}mm"
  end
end

