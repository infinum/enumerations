require_relative '../helpers/test_helper'
require_relative 'configuration'

module Configuration
  class FinderTest < Minitest::Test
    def setup
      Enumerations.configure do |config|
        config.primary_key        = :id
        config.foreign_key_suffix = :id
      end
    end

    def teardown
      Enumerations.restore_default_configuration
    end

    def test_lookup_by_key
      enum = CustomEnum.find(:draft)

      assert_equal :draft, enum.symbol
    end

    def test_lookup_by_string_key
      enum = CustomEnum.find('draft')

      assert_equal :draft, enum.symbol
    end

    def test_lookup_by_primary_key
      enum = CustomEnum.find(1)

      assert_equal :draft, enum.symbol
    end

    def test_lookup_by_primary_key_as_string
      enum = CustomEnum.find('1')

      assert_equal :draft, enum.symbol
    end
  end
end
