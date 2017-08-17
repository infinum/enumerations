module Configuration
  ::CustomConfigurationEnum = Class.new(Enumerations::Base)

  CustomConfigurationEnum.primary_key = :id
  CustomConfigurationEnum.value :draft, id: 1

  ::CustomConfigurationModel = Class.new(ActiveRecord::Base)
  CustomConfigurationModel.table_name = :custom_models
  CustomConfigurationModel.enumeration :custom_configuration_enum, foreign_key: :custom_enum_id

  class CustomConfigurationTest < Minitest::Test
    def test_primary_key_value
      assert_equal :id, CustomConfigurationEnum.primary_key
    end

    def test_primary_key_value_is_not_set_in_configuration
      assert_nil Enumerations.configuration.primary_key
    end

    def test_value_set_for_custom_foreign_key_config
      model = CustomConfigurationModel.new
      model.custom_configuration_enum = :draft

      assert_equal :draft, model.custom_configuration_enum.symbol
    end
  end
end
