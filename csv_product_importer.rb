require "csv"
require_relative "product_builder"

class CSVProductImporter

  attr_reader :products

  @@csv_parsing_options = {:headers => true, :return_headers => false, :skip_blanks => true}

  def initialize(csv_as_string)
    @products = parse(csv_as_string)
  end

  def parse(csv_as_string)
    products = []
    CSV.parse(csv_as_string, @@csv_parsing_options) do |csv_line|
      products << build_product_for(csv_line)
    end
    products
  end

  def build_product_for(product_details)
    ProductBuilder.build do |builder|
      builder.with_id(product_details.fetch("item id"))
      builder.with_description(product_details.fetch("description"))
      builder.with_price(product_details.fetch("price"))
      builder.with_cost(product_details.fetch("cost"))
      builder.with_price_type(product_details.fetch("price_type"))
      builder.with_quantity_on_hand(product_details.fetch("quantity_on_hand"))
    end
  end

end