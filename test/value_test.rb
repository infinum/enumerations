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

    assert_nil status.visible
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

  def test_enumeration_when_attribute_value_is_symbol
    role = Role.find(:lecturer)

    assert_equal role.type, 'croatist'
  end

  def test_enumeration_attribute_predicate_methods
    status = Status.none

    assert_equal status.name?, true
    assert_equal status.visible?, true
    assert_equal status.deleted?, false
  end

  def test_enumeration_attribute_predicate_method_on_undefined_attribute
    status = Status.deleted

    assert_equal status.name?, false
  end

  def test_enumeration_raises_error_for_nonexistent_attribute
    enum = Class.new(Enumerations::Base) do
      value :foobar
    end

    assert_raises NoMethodError do
      enum.foobar.name
    end
  end

  def test_enumeration_does_not_respond_to_nonexistent_attribute
    enum = Class.new(Enumerations::Base) do
      value :foobar
    end

    assert_equal enum.foobar.respond_to?(:name), false
  end

  def test_string_methods_on_value
    enum = Class.new(Enumerations::Base) do
      value :foobar
    end

    assert_equal enum.foobar.upcase, 'FOOBAR'
  end
end
