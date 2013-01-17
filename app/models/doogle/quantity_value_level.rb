class Doogle::QuantityValueLevel
  attr_accessor :index, :display_price, :quantity_column, :value_column
  def initialize(index, object)
    @index = index
    @object = object
    @quantity_column = "quantity#{index}"
    @value_column = "value#{index}"
    @price_or_cost = object.is_a?(Doogle::DisplayPrice) ? 'Price' : 'Cost'
  end
  def quantity
    @object.send(@quantity_column)
  end
  def value
    @object.send(@value_column)
  end
  def value?
    self.quantity.present? && self.value.present? && (self.quantity > 0) && (self.value > 0)
  end
  def quantity_label
    "Quantity #{@index}"
  end
  def value_label
    "#{@price_or_cost} #{@index}"
  end
end
