require_relative 'default_file_handler'

class ProductDataTransposer

    attr_reader :importers, :exporters, :and

    def initialize(file_handler=DefaultFileHandler.new)
        @importers = {}
        @exporters = {}
        @and = self
        @file_handler = file_handler
        @products = []
    end

    def register_exporter(exporter)
        raise "Invalid exporter" unless exporter.respond_to?("export")
        DelayedRegistration.new(@exporters, exporter)
    end

    def register_importer(importer)
        raise "Invalid importer" unless importer.respond_to?("import")
        DelayedRegistration.new(@importers, importer)
    end

    def import_from(filename)
        importer = importer_for(filename)
        data = @file_handler.read_data_from(filename)
        @products = importer.import(data)
        self
    end

    def export_to(filename)
        exporter = exporter_for(filename)
        data = exporter.export(@products)
        @file_handler.write_data_to(filename, data)
    end

    private
    def importer_for(filename)
        file_ext = file_extension_of(filename)
        raise "No registered importer for #{filename}" unless @importers.include?(file_ext)
        @importers[file_ext]
    end

    def exporter_for(filename)
        file_ext = file_extension_of(filename)
        raise "No register exporter for #{filename}" unless @exporters.include?(file_ext)
        @exporters[file_ext]
    end

    def file_extension_of(filename)
        file_ext = File.extname(filename)
        file_ext[1..-1]
    end

    class DelayedRegistration
        
        def initialize(hash, item)
            @hash = hash
            @item = item
        end

        def for_file_type(fileType)
            @hash[fileType] = @item
        end

    end
end