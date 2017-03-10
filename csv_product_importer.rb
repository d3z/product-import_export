require "csv"
require_relative "product_builder"

class CSVProductImporter

  attr_reader :products

  CSV_PARSING_OPTIONS = {:headers => true, :return_headers => false, :skip_blanks => true}

  def import(csv_as_string)
    products = []
    CSV.parse(csv_as_string, CSV_PARSING_OPTIONS) do |csv_line|
      products << build_product_for(csv_line)
    end
    products
  end

  private
  def build_product_for(product_details)
    ProductBuilder.build do |builder|
      add_normal_fields(builder, product_details)
      add_modifier_fields(builder, product_details)
    end
  end

  def add_normal_fields(builder, product_details)
    builder.with_id(product_details["item id"])
    builder.with_description(product_details["description"])
    builder.with_price(product_details["price"])
    builder.with_cost(product_details["cost"])
    builder.with_price_type(product_details["price_type"])
    builder.with_quantity_on_hand(product_details["quantity_on_hand"])
  end

  def add_modifier_fields(builder, product_details)
    field_hash = product_details.to_hash
    modifier_names = field_hash.select { |key, value| key.match(/modifier_\d*?_name/) }
    modifier_names.each do |key, modifier_name|
      modifier_price_key = key.gsub(/name/, "price")
      modifier_price = product_details[modifier_price_key]
      builder.add_modifier(modifier_name, modifier_price)
    end
  end

end
