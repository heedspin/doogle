class Doogle::CharacterRowsRange < Doogle::ActiveRange
  self.data = [
    { :id => 1, :max => 1, :min => 1 },
    { :id => 2, :min => 2, :max => 2 },
    { :id => 3, :min => 2, :max => 5 },
    { :id => 4, :min => 5 }
  ]
end

