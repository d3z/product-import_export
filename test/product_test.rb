require 'test/unit'
require_relative '../product'

class ProductTest < Test::Unit::TestCase

  def test_product_is_created_with_empty_modifiers_list
    product = Product.new(1)
    assert_equal(product.modifiers, [])
  end

  def test_product_builder_builds_valid_product
    product = ProductBuilder.new(1).build
    assert_equal(product.id, 1)
  end

  def test_builder_can_add_a_modifier_to_the_product
    modifier = Modifier.new('Dummy modifier', 42.0)
    product = ProductBuilder.new(1).add_modifier(modifier).build
    assert_equal(product.modifiers.count, 1)
    assert_equal(product.modifiers[0], modifier)
  end

end