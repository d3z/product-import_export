require 'csv'
require_relative 'product'

class CSVProductImporter

  attr_reader :products

  @@csv_parsing_options = {:headers => true, :return_headers => false, :skip_blanks => true}

  def initialize(csv_as_string)
    @products = parse(csv_as_string)
  end

  def parse(csv_as_string)
    products = []
    CSV.parse(csv_as_string, @@csv_parsing_options) do |csv_line|
      products << build_product_for(csv_line) unless csv_line.fields.compact.empty?
    end
    products
  end

  def build_product_for(product_details)
    ProductBuilder.new(product_details.fetch('item id'))
                  .build
  end

end