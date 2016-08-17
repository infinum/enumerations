require_relative 'test_helper'

class VersionTest < Minitest::Test
  def test_version
    assert_equal '2.0.0', Enumerations::VERSION
  end
end
