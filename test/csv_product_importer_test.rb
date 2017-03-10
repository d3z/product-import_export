require "test/unit"

require_relative "../csv_product_importer"

class CSVProductImporterTest < Test::Unit::TestCase

  def setup
    @target = CSVProductImporter.new
  end

  def test_importer_ignores_csv_header
    products = @target.import(csv_header_without_modifiers)
    assert_equal(0, products.length)
  end

  def test_importer_ignores_empty_lines_in_csv
    products = @target.import(csv_without_modifiers_and_with_empty_line)
    assert_equal(1, products.length)
  end

  def test_importer_creates_product_from_csv
    products = @target.import(csv_without_modifiers_and_with_a_single_product)
    assert_equal(1, products.length)
    # TODO: this is ugly ... it might be nicer to assert against a Product instance
    product = products[0]
    assert_equal("111010", product.id)
    assert_equal("Coffee", product.description)
    assert_equal(1.25, product.price)
    assert_equal(0.8, product.cost)
    assert_equal("system", product.price_type)
    assert_equal(100000, product.quantity_on_hand)
  end

  def test_importer_adds_modifiers_from_items
    products = @target.import(csv_with_modifiers)
    product = products[0]
    assert_equal(2, product.modifiers.length)
    assert_equal("medium", product.modifiers[1].name)
    assert_equal(0.80, product.modifiers[1].price)
  end

  private
  def csv_header_without_modifiers
    "item id,description,price,cost,price_type,quantity_on_hand"
  end

  def csv_without_modifiers_and_with_empty_line
    "#{csv_header_without_modifiers}\n\n111010,Coffee,$1.25,$0.80,system,100000"
  end

  def csv_without_modifiers_and_with_a_single_product
    "#{csv_header_without_modifiers}\n111010,Coffee,$1.25,$0.80,system,100000"
  end

  def csv_header_with_modifiers
    "#{csv_header_without_modifiers},modifier_1_name,modifier_1_price,modifier_2_name,modifier_2_price"
  end

  def csv_with_modifiers
    "#{csv_header_with_modifiers}\n111010,Coffee,$1.25,$0.80,system,100000,small,$0.45,medium,$0.80"
  end
end
