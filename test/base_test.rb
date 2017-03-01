require_relative 'helpers/test_helper'

class BaseTest < Minitest::Test
  def test_all
    statuses = Status.all

    assert_equal 5, statuses.size
    assert_equal statuses.first, Status.draft
  end

  def test_symbols
    status_symbols = Status.symbols

    assert_equal 5, status_symbols.size
    assert_equal status_symbols.first, Status.draft.to_sym
  end

  def test_duplicated_symbol
    assert_raises EnumerationsError, 'Duplicate symbol draft' do
      obj = Class.new(Enumerations::Base)

      obj.value :draft, id: 1, name: 'Draft'
      obj.value :draft, id: 2, name: 'Draft Again'
    end
  end

  def test_all_has_custom_attributes
    statuses = Status.all

    assert_silent do
      statuses.map(&:visible)
      statuses.map(&:deleted)
    end
  end

  def test_enumerations_custom_instance_method
    role = Role.find(:admin)

    assert_equal 'user_Admin', role.my_custom_name
  end

  def test_all_enumerations_has_custom_instance_methods
    roles = Role.all

    assert_silent do
      roles.map(&:my_custom_name)
    end
  end
end
