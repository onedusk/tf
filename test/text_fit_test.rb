# frozen_string_literal: true

require "test_helper"

class TextFitTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TextFit::VERSION
  end

  def test_convenience_method
    result = TextFit.calculate(0, 0, 100, 50, "hello", "bonjour")
    assert_instance_of TextFit::Result, result
    assert result.font_size.positive?
  end
end
