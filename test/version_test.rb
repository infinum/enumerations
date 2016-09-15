require_relative 'helpers/test_helper'

class VersionTest < Minitest::Test
  def test_version
    assert_equal '2.1.0', Enumerations::VERSION
  end
end
