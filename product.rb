class Product

  attr_accessor :id, :description, :price, :cost, :price_type, :quantity_on_hand, :modifiers

  def initialize
    @modifiers = []
  end

  def to_json(options=nil)
    {
      "item id" => @id,
      "description" => @description,
      "price" => @price,
      "cost" => @cost,
      "price_type" => @price_type,
      "quantity_on_hand" => @quantity_on_hand,
      "modifiers" => @modifiers
    }.to_json
  end

end

class Modifier

  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def to_json(options=nil)
    {
      "name" => @name,
      "price" => @price
    }.to_json
  end

end