require_relative 'helpers/test_helper'

class ConfigurationTest < Minitest::Test
  def test_default_primary_key
    primary_key = Enumerations.configuration.primary_key

    assert_equal nil, primary_key
  end

  def test_custom_primary_key
    Enumerations.configure { |config| config.primary_key = :id }
    primary_key = Enumerations.configuration.primary_key

    assert_equal :id, primary_key
  end
end
