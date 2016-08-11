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

  def test_equal_by_id
    status = Status.find(:draft)

    assert_equal true, status == 1
  end

  def test_equal_by_symbol
    status = Status.draft

    assert_equal true, status == :draft
  end

  def test_equal_by_enumeration
    status = Status.draft

    assert_equal true, status == Status.draft
  end

  def test_not_equal_by_enumeration
    status = Status.draft

    assert_equal false, status == Status.published
  end
end
