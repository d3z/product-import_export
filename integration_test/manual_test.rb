require_relative "../product_data_transposer"
require_relative "../csv_product_importer"
require_relative "../json_product_exporter"

transposer = ProductDataTransposer.new
importer = CSVProductImporter.new
exporter = JSONProductExporter.new

transposer.register_importer(importer).for_file_type("csv")
transposer.register_exporter(exporter).for_file_type("json")

time = Time.now.getutc
transposer.import_from("../data/example.csv").and.export_to("../data/example#{time}.json")