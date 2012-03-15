class Doogle::LogicOperatingVoltageRange < Doogle::ActiveRange
  self.data = [
    { :id => 1, :min => 3.0, :max => 3.0 },
    { :id => 2, :min => 3.3, :max => 3.3 },
    { :id => 3, :min => 5.0, :max => 5.0 }
  ]
  
  def value_to_s(value)
    "#{value}v"
  end
end

