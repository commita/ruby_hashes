require 'test_helper'

class ConverterTest < MiniTest::Test
  def test_ignores_complex_old_style
    input = %q[{ :"x"=>13, :y => 31 }]
    converter = RubyHashes::Converter.new(input)
    assert_equal input, converter.to_new_style
  end

  def test_converts_simple_old_style_to_new_style
    input = %q[{ :x=>13, :y => 31 }]
    expected = %q[{ x: 13, y: 31 }]
    converter = RubyHashes::Converter.new(input)
    assert_equal expected, converter.to_new_style
  end

  def test_converts_multiline_simple_old_style_to_multiline_new_style
    input = %q[{
      :x=>13,
      :y => 31,
    }].gsub(/^ {4}/m, '')

    expected = %q[{
      x: 13,
      y: 31,
    }].gsub(/^ {4}/m, '')

    converter = RubyHashes::Converter.new(input)
    assert_equal expected, converter.to_new_style
  end

  def test_converts_mixed_styles_to_new_style
    input = %q[{ :x=>13, y: 31, :z => 44, w:88 }]
    expected = %q[{ x: 13, y: 31, z: 44, w: 88 }]
    converter = RubyHashes::Converter.new(input)
    assert_equal expected, converter.to_new_style
  end

  def test_converts_nested_simple_old_style_to_new_style
    input = %q[{
      :x=>13,
      y: 31,
      :z => {
        :i => 44,
        j: 88,
      },
    }].gsub(/^ {4}/m, '')

    expected = %q[{
      x: 13,
      y: 31,
      z: {
        i: 44,
        j: 88,
      },
    }].gsub(/^ {4}/m, '')

    converter = RubyHashes::Converter.new(input)
    assert_equal expected, converter.to_new_style
  end

  def test_converts_old_style_to_new_style_and_keeps_indentation
    input = %q[{
      :x           => 13,
      :key         => 31,
      :another_key => 44,
    }].gsub(/^ {4}/m, '')

    expected = %q[{
      x:           13,
      key:         31,
      another_key: 44,
    }].gsub(/^ {4}/m, '')

    converter = RubyHashes::Converter.new(input)
    assert_equal expected, converter.to_new_style
  end
end
