require 'test/unit'
require_relative '../csv_product_importer'

class CSVProductImporterTest < Test::Unit::TestCase

  def test_ignore_csv_header
    target = CSVProductImporter.new(csv_header_without_modifiers)
    assert_equal(0, target.products.length)
  end

  def test_ignores_empty_lines_in_csv
    target = CSVProductImporter.new(csv_without_modifiers_and_with_empty_line)
    assert_equal(1, target.products.length)
  end

  def csv_header_without_modifiers
    "item id,description,price,cost,price_type,quantity_on_hand"
  end

  def csv_without_modifiers_and_with_empty_line
    "#{csv_header_without_modifiers}\n   \n1,'marvin',42.0,42.0,'system',0"
  end

end