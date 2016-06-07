require_relative 'test_helper'

class VersionTest < Test::Unit::TestCase
  def test_version
    assert_equal '1.1.0', Enumeration::VERSION
  end
end
