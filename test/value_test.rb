require_relative 'test_helper'

class ValueTest < Minitest::Test
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
