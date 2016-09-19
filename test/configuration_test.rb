require_relative 'helpers/test_helper'

class ConfigurationTest < Minitest::Test
  def setup
    Enumerations.restore_default_configuration
  end

  def teardown
    Enumerations.restore_default_configuration
  end

  def test_default_configuration
    assert_equal nil, Enumerations.configuration.primary_key
    assert_equal nil, Enumerations.configuration.foreign_key_suffix
  end

  def test_custom_configuration
    Enumerations.configure do |config|
      config.primary_key        = :id
      config.foreign_key_suffix = :id
    end

    assert_equal :id, Enumerations.configuration.primary_key
    assert_equal :id, Enumerations.configuration.foreign_key_suffix
  end

  def test_reflection_with_configured_foreign_key_suffix
    Enumerations.configure { |config| config.foreign_key_suffix = :id }

    reflection = Enumerations::Reflection.new(:status)

    assert_equal 'Status',   reflection.class_name
    assert_equal ::Status,   reflection.enumerator_class
    assert_equal :status_id, reflection.foreign_key
  end

  def test_required_primary_key_when_primary_key_configured
    Enumerations.configure { |config| config.primary_key = :id }

    assert_raises 'Enumeration primary key is required' do
      Class.new(Enumerations::Base).value draft: { name: 'Draft' }
    end
  end

  def test_duplicated_primary_key_when_primary_key_configured
    Enumerations.configure { |config| config.primary_key = :id }

    assert_raises 'Duplicate primary key 1' do
      Class.new(Enumerations::Base).values draft: { id: 1, name: 'Draft' },
                                           test:  { id: 1, name: 'Draft' }
    end
  end
end
