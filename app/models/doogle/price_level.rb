class Doogle::PriceLevel
  attr_accessor :index, :display_price, :quantity_column, :price_column, :cost_column
  def initialize(index, object)
    @index = index
    @object = object
    @quantity_column = "quantity#{index}"
    @price_column = "price#{index}"
    @cost_column = "cost#{index}"
  end
  def quantity
    @object.send(@quantity_column)
  end
  def quantity=(v)
    @object.send("#{@quantity_column}=", v)
  end
  def price
    @object.send(@price_column)
  end
  def price=(v)
    @object.send("#{@price_column}=", v)
  end
  def cost
    @object.send(@cost_column)
  end
  def cost=(v)
    @object.send("#{@cost_column}=", v)
  end
  def quantity_label
    "Quantity #{@index}"
  end
  def price_label
    "Price #{@index}"
  end
  def cost_label
    "Cost #{@index}"
  end
  def margin
    return nil unless self.used?
    (self.price - self.cost) / self.price
  end
  def used?
    self.quantity.present? && self.cost.present? && self.price.present? # && (self.quantity > 0) && (self.cost > 0) and (self.price > 0)
  end
  def to_s
    "#{self.quantity}: #{self.cost || 'nil'} - #{self.price || 'nil'}"
  end
end
