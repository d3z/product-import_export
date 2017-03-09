class Product

  attr_accessor :id, :description, :price, :cost, :price_type, :quantity_on_hand, :modifiers

  def initialize
    @modifiers = []
  end

end

class Modifier

  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

end