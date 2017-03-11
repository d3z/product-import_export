# Deals with creating Product instances.
# example:
#   product = ProductBuilder.build do |builder|
#     builder.with_id(1)
#     builder.with_description("A shiny new product")
#   end
#
# Why a builder?
# Apart from keeping constructors shorter and making
# distinct the difference between required and optional
# fields, they help in testing. With a builder, we only
# need set the fields that we"re testing rather than
# call, possibly long, constructors in each test.

require_relative 'product'

class ProductBuilder

  def self.build
    product_builder = new
    yield(product_builder)
    product_builder.product
  end

  attr_reader :product

  def initialize
    @product = Product.new
  end

  def with_id(id)
    @product.id = id
  end

  def with_description(description)
    @product.description = description
  end

  def with_price(price)
    @product.price = convert_currency_string_to_numeric(price)
  end

  def with_cost(cost)
    @product.cost = convert_currency_string_to_numeric(cost)
  end

  def with_price_type(price_type)
    validate_price_type(price_type)
    @product.price_type = price_type
  end

  def with_quantity_on_hand(quantity_on_hand)
    @product.quantity_on_hand = Integer(quantity_on_hand)
  rescue
    @product.quantity_on_hand = nil
  end

  def add_modifier(name, price)
    modifier = Modifier.new(name, convert_currency_string_to_numeric(price))
    @product.modifiers << modifier
  end

  VALID_PRICE_TYPES = ["system", "open"]

  private
  def validate_price_type(price_type)
    raise "Invalid price type #{price_type}" unless VALID_PRICE_TYPES.include?(price_type)
  end

  def convert_currency_string_to_numeric(value)
    return nil if value == nil
    currency_without_symbol = value.gsub(/\$/,"")
    Float(currency_without_symbol)
  rescue
    raise "Invalid currency value #{value}"
  end

end