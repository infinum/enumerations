require_relative 'test_helper'

class BaseTest < Test::Unit::TestCase
  def test_lookup_by_symbol
    status = Status.find(:draft)

    assert_equal :draft, status.symbol
  end

  def test_lookup_fail_by_symbol
    status = Status.find(:draft)

    assert_not_equal :published, status.symbol
  end

  def test_all
    statuses = Status.all

    assert_equal 5, statuses.size
    assert_equal statuses.first, Status.draft
  end

  def test_duplicated_id
    assert_raise 'Duplicate id 1' do
      Class.new.values draft: { id: 1, name: 'Draft' },
                       test:  { id: 1, name: 'Draft' }
    end
  end

  def test_duplicated_symbol
    assert_raise 'Duplicate symbol draft' do
      obj = Class.new

      obj.value :draft, id: 1, name: 'Draft'
      obj.value :draft, id: 2, name: 'Draft Again'
    end
  end

  def test_all_has_custom_attributes
    statuses = Status.all

    assert_nothing_raised NoMethodError do
      statuses.map(&:visible)
      statuses.map(&:deleted)
    end
  end

  def test_with_defined_custom_attributes_visible
    status = Status.find(:none)

    assert_equal true, status.visible
  end

  def test_with_defined_custom_attributes_deleted
    status = Status.find(:deleted)

    assert_equal true, status.deleted
  end

  def test_without_defined_custom_attributes
    status = Status.find(:draft)

    assert_equal nil, status.visible
  end
end
