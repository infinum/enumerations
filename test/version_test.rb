require_relative 'test_helper'

class VersionTest < Minitest::Test
  def test_version
    assert_equal '1.3.0', Enumeration::VERSION
  end
end
