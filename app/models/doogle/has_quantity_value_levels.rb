module Doogle::HasQuantityValueLevels
  TOTAL=8
  def levels
    @levels ||= (1..TOTAL).map { |x| Doogle::QuantityValueLevel.new(x, self) }
  end
  def levels_used
    self.levels.select(&:value?)
  end
end
