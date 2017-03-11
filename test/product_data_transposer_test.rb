require 'test/unit'

require_relative '../product_data_transposer'

class ProductDataTransformerTest < Test::Unit::TestCase

    def setup
        @target = ProductDataTransposer.new(DummyFileLoader.new)
    end

    def test_transformer_raises_an_error_when_registering_an_invalid_exporter
        assert_raises(RuntimeError) {
            # Object has not 'export' method
            @target.register_exporter(Object.new)
        }
    end   

    def test_transformer_raises_an_error_when_registering_an_invalid_importer
        assert_raises(RuntimeError) {
            # Object has no 'import' method
            @target.register_importer(Object.new)
        }
    end

    def test_transformer_returns_delayed_registration_for_valid_exporter
        reg = @target.register_exporter(DummyExporter.new)
        assert_true(reg.respond_to?('for_file_type'))
    end

    def test_transformer_returns_delayed_registration_for_valid_importer
        reg = @target.register_importer(DummyImporter.new)
        assert_true(reg.respond_to?('for_file_type'))
    end

    def test_transformer_registers_exporter_for_file_type
        exporter = DummyExporter.new
        @target.register_exporter(exporter).for_file_type('json')
        assert_true(@target.exporters.include?('json'))
        assert_equal(exporter, @target.exporters['json'])
    end

    def test_transformer_registers_importer_for_file_type
        importer = DummyImporter.new
        @target.register_importer(importer).for_file_type('csv')
        assert_true(@target.importers.include?('csv'))
        assert_equal(importer, @target.importers['csv'])
    end

    def test_transformer_uses_correct_importer_for_file_type
        importer = DummyImporter.new
        @target.register_importer(importer).for_file_type('csv')
        @target.import_from('test.csv')
        assert_true(importer.import_was_called) 
    end

    def test_transformer_raises_an_error_on_unregistered_importer
        assert_raises(RuntimeError) {
            @target.import_from('test.csv')
        }
    end

    def test_transformer_uses_correct_exporter_for_file_type
        exporter = DummyExporter.new
        @target.register_exporter(exporter).for_file_type('json')
        @target.export_to('test.json')
        assert_true(exporter.export_was_called) 
    end

    def test_transformer_raises_an_error_on_unregistered_exporter
        assert_raises(RuntimeError) {
            @target.export_to('test.json')
        }
    end

    private
    class DummyFileLoader
        attr_reader :read_was_called, :write_was_called
        @read_was_called = false
        @write_was_called = false
        def read_data_from(filename)
            @read_was_called = true
            ""
        end
        def write_data_to(filename, data)
            @write_was_called = true
        end
    end

    class DummyExporter
        attr_reader :export_was_called
        @export_was_called = false
        def export(data)
            @export_was_called = true
        end
    end
    
    class DummyImporter
        attr_reader :import_was_called
        @import_was_called = false
        def import(data)
            @import_was_called = true
        end
    end

end