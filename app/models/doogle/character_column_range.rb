class Doogle::CharacterColumnRange < Doogle::ActiveRange
  self.data = [
    {:id => 1, :max => 10 },
    {:id => 2, :min => 10, :max => 20 },
    {:id => 3, :min => 20},
  ]
end

