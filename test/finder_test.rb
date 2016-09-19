require_relative 'helpers/test_helper'

class FinderTest < Minitest::Test
  def test_lookup_by_symbol
    status = Status.find(:draft)

    assert_equal :draft, status.symbol
  end

  def test_lookup_fail_by_symbol
    status = Status.find(:draft)

    refute_same :published, status.symbol
  end

  def test_lookup_by_string_key
    status = Status.find('draft')

    assert_equal :draft, status.symbol
  end

  def test_find_by
    status = Status.find_by(name: 'Draft')

    assert_equal :draft, status.symbol
  end

  def test_fail_find_by
    status = Status.find_by(name: 'Draft1')

    assert_equal nil, status
  end

  def test_where_by_name
    statuses = Status.where(name: 'Draft')

    assert_equal [Status.find(:draft)], statuses
  end

  def test_where_by_name_with_no_results
    statuses = Status.where(name: 'Draft1')

    assert_equal [], statuses
  end

  def test_where_by_custom_attributes
    roles = Role.where(admin: true)

    assert_equal 2, roles.count
    assert_equal [:admin, :editor], roles.map(&:symbol)
  end

  def test_where_by_multiple_custom_attributes
    roles = Role.where(admin: true, active: true)

    assert_equal 1, roles.count
    assert_equal [:admin], roles.map(&:symbol)
  end

  def test_where_by_undefined_custom_attributes
    roles = Role.where(description1: false)

    assert_equal [], roles
  end
end
