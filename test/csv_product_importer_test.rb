require "test/unit"
require_relative "../csv_product_importer"

class CSVProductImporterTest < Test::Unit::TestCase

  def test_importer_ignores_csv_header
    target = CSVProductImporter.new(csv_header_without_modifiers)
    assert_equal(0, target.products.length)
  end

  def test_importer_ignores_empty_lines_in_csv
    target = CSVProductImporter.new(csv_without_modifiers_and_with_empty_line)
    assert_equal(1, target.products.length)
  end

  def test_importer_creates_product_from_csv
    target = CSVProductImporter.new(csv_without_modifiers_and_with_a_single_product)
    assert_equal(1, target.products.length)
    # TODO: this is ugly ... it might be nicer to assert against a Product instance
    product = target.products[0]
    assert_equal("111010", product.id)
    assert_equal("Coffee", product.description)
    assert_equal(1.25, product.price)
    assert_equal(0.8, product.cost)
    assert_equal("system", product.price_type)
    assert_equal(100000, product.quantity_on_hand)
  end

  private
  def csv_header_without_modifiers
    "item id,description,price,cost,price_type,quantity_on_hand"
  end

  def csv_without_modifiers_and_with_empty_line
    "#{csv_header_without_modifiers}\n   \n1,'marvin',42.0,42.0,'system',0"
  end

  def csv_without_modifiers_and_with_a_single_product
    "#{csv_header_without_modifiers}\n111010,Coffee,$1.25,$0.80,system,100000"
  end
end