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
    modifier_name = "Dummy modifier"
    modifier_price = "$42.03"
    product = ProductBuilder.build do |builder|
      builder.add_modifier(modifier_name, modifier_price)
    end
    assert_equal(product.modifiers.count, 1)
    assert_equal(product.modifiers[0].name, modifier_name)
    assert_equal(product.modifiers[0].price, 42.03)
  end

  def test_bulder_raises_error_on_invalid_price_for_modifier
    assert_raises(RuntimeError) {
      ProductBuilder.build do |builder|
        builder.add_modifier("dummy", "this_is_not_my_money")
      end
    }
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
    {
      "$100" => 100.0, 
      "$100.01" => 100.01, 
      "100.02" => 100.02,
      "-$10.40" => -10.4}.each do |string, value|
      product = ProductBuilder.build do |builder|
        builder.with_price(string)
      end
      assert_equal(value, product.price)
    end
  end

  def test_builder_converts_numeric_values
    product = ProductBuilder.build do |builder|
      builder.with_quantity_on_hand("100")
    end
    assert_equal(100, product.quantity_on_hand)
  end

  def test_builder_ignores_invalid_numeric_values
    product = ProductBuilder.build do |builder|
      builder.with_quantity_on_hand("WAH!")
    end
    assert_equal(nil, product.quantity_on_hand)
  end

  def test_builder_does_not_try_to_convert_nil_currency_values
    product = ProductBuilder.build do |builder|
      builder.with_price(nil)
    end
    assert_equal(nil, product.price)
  end

end
