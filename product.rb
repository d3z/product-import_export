class Product

  attr_accessor :id, :description, :price, :cost, :price_type, :quantity_on_hand, :modifiers

  def initialize(id)
    @id = id
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

class ProductBuilder

  def initialize(id)
    @product = Product.new(id)
  end

  def with_description(description)
    @product.description = description
    self
  end

  def with_price(price)
    @product.price = price
    self
  end

  def with_cost(cost)
    @product.cost = cost
    self
  end

  def with_price_type(price_type)
    @product.price_type = price_type
    self
  end

  def with_quantity_on_hand(quantity_on_hand)
    @product.quantity_on_hand = quantity_on_hand
    self
  end

  def add_modifier(modifier)
    @product.modifiers << modifier
    self
  end

  def build
    @product
  end

end