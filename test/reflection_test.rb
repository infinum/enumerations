require_relative 'test_helper'

class ReflectionTest < Test::Unit::TestCase
  def test_reflections
    reflection = Enumeration::Reflection.new(:role, class_name: 'Role', foreign_key: :role_id)

    assert_equal :role, reflection.name
    assert_equal 'Role', reflection.class_name
    assert_equal :role_id, reflection.foreign_key
  end
end
