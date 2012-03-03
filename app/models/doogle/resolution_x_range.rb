class Doogle::ResolutionXRange < Doogle::ActiveRange
  self.data = [
    {:id => 1, :max => 128 },
    {:id => 2, :min => 128, :max => 256},
    {:id => 3, :min => 256, :max => 512},
    {:id => 4, :min => 512, :max => 1024},
    {:id => 5, :min => 800, :max => 800},
    {:id => 6, :min => 1024},
  ]
end

