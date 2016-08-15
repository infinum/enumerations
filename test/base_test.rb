require_relative 'test_helper'

class BaseTest < Minitest::Test
  def test_lookup_by_symbol
    status = Status.find(:draft)

    assert_equal :draft, status.symbol
  end

  def test_lookup_fail_by_symbol
    status = Status.find(:draft)

    refute_same :published, status.symbol
  end

  def test_find_by
    status = Status.find_by(name: 'Draft')

    assert_equal :draft, status.symbol
  end

  def test_fail_find_by
    status = Status.find_by(name: 'Draft1')

    assert_equal nil, status
  end

  def test_all
    statuses = Status.all

    assert_equal 5, statuses.size
    assert_equal statuses.first, Status.draft
  end

  def test_required_id
    assert_raises 'Enumeration id is required' do
      Class.new.value draft: { name: 'Draft' }
    end
  end

  def test_duplicated_id
    assert_raises 'Duplicate id 1' do
      Class.new.values draft: { id: 1, name: 'Draft' },
                       test:  { id: 1, name: 'Draft' }
    end
  end

  def test_duplicated_symbol
    assert_raises 'Duplicate symbol draft' do
      obj = Class.new

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
