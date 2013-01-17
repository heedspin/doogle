module Doogle::HasQuantityValueLevels
  def levels
    @levels ||= (1..6).map { |x| Doogle::QuantityValueLevel.new(x, self) }
  end
  def levels_used
    self.levels.select(&:value?)
  end
end
