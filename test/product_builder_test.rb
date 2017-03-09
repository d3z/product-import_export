require "test/unit"
require_relative "../product_builder"
require_relative "../product"

class ProductBuilderTest < Test::Unit::TestCase

  def test_product_is_created_with_empty_modifiers_list
    product = ProductBuilder.build do |builder|
      builder.with_id(1)
    end
    assert_equal(product.modifiers, [])
  end

  def test_product_builder_builds_valid_product
    product = ProductBuilder.build do |builder|
      builder.with_id(1)
    end
    assert_equal(product.id, 1)
  end

  def test_builder_can_add_a_modifier_to_the_product
    modifier = Modifier.new("Dummy modifier", 42.0)
    product = ProductBuilder.build do |builder|
      builder.add_modifier(modifier)
    end
    assert_equal(product.modifiers.count, 1)
    assert_equal(product.modifiers[0], modifier)
  end

  def test_builder_raises_error_on_invalid_price_type
    assert_raise(RuntimeError) {
      ProductBuilder.build do |builder|
        builder.with_price_type("wtf_is_this?")
      end
    }
  end

  def test_builder_does_not_raise_error_on_valid_price_type
    product = ProductBuilder.build do |builder|
      builder.with_price_type("open")
    end
    assert_equal("open", product.price_type)
  end

  def test_builder_raises_error_on_invalid_currency_value
    assert_raise(RuntimeError) {
      ProductBuilder.build do |builder|
        builder.with_price("not_real_money")
      end
    }
  end

  def test_builder_converts_currency_value_to_number
    {"$100" => 100.0, "$100.01" => 100.01, "100.02" => 100.02}.each do |string, value|
      product = ProductBuilder.build do |builder|
        builder.with_price(string)
      end
      assert_equal(value, product.price)
    end
  end

end