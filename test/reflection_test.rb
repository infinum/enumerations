require_relative 'helpers/test_helper'

class ReflectionTest < Minitest::Test
  def test_reflection_with_all_attributes
    reflection = Enumerations::Reflection.new(:status, class_name: 'Status',
                                                       foreign_key: :status)

    assert_equal :status,  reflection.name
    assert_equal 'Status', reflection.class_name
    assert_equal :status,  reflection.foreign_key
    assert_equal ::Status, reflection.enumerator_class
  end

  def test_reflection_without_class_name_and_foreign_key
    reflection = Enumerations::Reflection.new(:status)

    assert_equal :status,   reflection.name
    assert_equal 'Status',  reflection.class_name
    assert_equal :status,   reflection.foreign_key
    assert_equal ::Status,  reflection.enumerator_class
  end

  def test_reflection_with_custom_name_and_without_foreign_key
    reflection = Enumerations::Reflection.new(:my_status, class_name: 'Status')

    assert_equal :my_status,  reflection.name
    assert_equal 'Status',    reflection.class_name
    assert_equal :my_status,  reflection.foreign_key
    assert_equal ::Status,    reflection.enumerator_class
  end

  def test_reflection_with_class_name_as_constant
    reflection = Enumerations::Reflection.new(:status, class_name: Status)

    assert_equal 'Status', reflection.class_name
    assert_equal ::Status, reflection.enumerator_class
  end
end
