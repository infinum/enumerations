require_relative '../helpers/test_helper'
require_relative 'Configuration'

module Configuration
  class EnumerationsTest < Minitest::Test
    def setup
      Enumerations.configure do |config|
        config.primary_key        = :id
        config.foreign_key_suffix = :id
      end
    end

    def teardown
      Enumerations.restore_default_configuration
    end

    def test_model_enumeration_assignment
      model = CustomModel.new
      model.custom_enum = CustomEnum.draft

      assert_equal 'draft', model.custom_enum.to_s
    end

    def test_model_bang_assignment
      model = CustomModel.new
      model.custom_enum_draft!

      assert_equal 'draft', model.custom_enum.to_s
    end

    def test_model_via_symbol_assignment
      model = CustomModel.new
      model.custom_enum = CustomEnum.published.symbol

      assert_equal 'published', model.custom_enum.to_s
    end

    def test_model_via_foreign_key_assignment
      model = CustomModel.new
      model.custom_enum_id = CustomEnum.published.id

      assert_equal 'published', model.custom_enum.to_s
    end

    def test_enumerated_class_scope_hash_value
      query_hash = CustomModel.with_custom_enum_draft.where_values_hash.symbolize_keys

      assert_equal query_hash, custom_enum_id: 1
    end
  end
end
