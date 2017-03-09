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
    @product.quantity_on_hand = Float(quantity_on_hand)
  rescue
    raise "Invalid numeric value #{quantity_on_hand}"
  end

  def add_modifier(modifier)
    @product.modifiers << modifier
  end

  VALID_PRICE_TYPES = ["system", "open"]

  private
  def validate_price_type(price_type)

    raise "Invalid price type #{price_type}" unless VALID_PRICE_TYPES.include?(price_type)
  end

  def convert_currency_string_to_numeric(value)
    # let"s be super-lazy and just work with dollar values here
    # also, we"re not dealing with comma"s in the value here
    # like I said, super-lazy
    currency_without_symbol = /(?:\$)?(\d*(?:\.\d{2})?)/.match(value)[1]
    Float(currency_without_symbol)
  rescue
    raise "Invalid currency value #{value}"
  end

end