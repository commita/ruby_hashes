require 'test_helper'

class RubyHashesTest < MiniTest::Test
  def test_top_level_module_must_have_a_defined_version
    refute_nil ::RubyHashes::VERSION
  end
end
