require_relative 'helpers/test_helper'

class ValueTest < Minitest::Test
  def test_equal_by_symbol
    status = Status.draft

    assert_equal true, status == :draft
  end

  def test_equal_by_string
    status = Status.draft

    assert_equal true, status == 'draft'
  end

  def test_equal_by_enumeration
    status = Status.draft

    assert_equal true, status == Status.draft
  end

  def test_not_equal_by_enumeration
    status = Status.draft

    assert_equal false, status == Status.published
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

  def test_enumeration_to_i_return_ordinal
    first_status = Status.find(:draft)
    second_status = Status.find(:review_pending)

    assert_equal first_status.to_i, 1
    assert_equal second_status.to_i, 2
  end

  def test_enumeration_to_sym
    status = Status.find(:draft)

    assert_equal status.to_sym, :draft
  end

  def test_enumeration_to_param
    status = Status.find(:draft)

    assert_equal status.to_param, 'draft'
  end
end
