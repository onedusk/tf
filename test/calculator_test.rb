# frozen_string_literal: true

require "test_helper"

class CalculatorTest < Minitest::Test
  def setup
    @calculator = TextFit::Calculator.new
  end

  def test_basic_calculation
    result = @calculator.calculate(0, 0, 100, 50, "hello", "hello")
    assert_equal 50, result.font_size
    assert_equal 50, result.original_size
    assert_equal 0, result.iterations
    assert result.fitted
  end

  def test_longer_translated_text
    result = @calculator.calculate(0, 0, 100, 50, "hi", "hello world this is much longer")
    assert result.font_size < result.original_size
    assert result.iterations.positive?
  end

  def test_text_does_not_fit
    # Very long text in small box
    result = @calculator.calculate(0, 0, 10, 10, "a", "a" * 10000)
    refute result.fitted
    assert_in_delta 3.0, result.font_size, 0.5 # Should hit minimum (0.3 * 10)
  end

  def test_custom_configuration
    config = TextFit::Configuration.new(delta: 0.25, min_size_factor: 0.5)
    calculator = TextFit::Calculator.new(config: config)
    result = calculator.calculate(0, 0, 100, 50, "hi", "hello world this is longer")

    assert result.font_size >= 25 # min_size_factor is 0.5, so minimum is 0.5 * 50 = 25
  end

  def test_validates_numeric_coordinates
    assert_raises(ArgumentError) do
      @calculator.calculate("0", 0, 100, 50, "hello", "world")
    end
  end

  def test_validates_string_texts
    assert_raises(ArgumentError) do
      @calculator.calculate(0, 0, 100, 50, 123, "world")
    end
  end

  def test_validates_positive_area
    assert_raises(ArgumentError) do
      @calculator.calculate(0, 0, 0, 50, "hello", "world")
    end
  end

  def test_batch_processing
    items = [
      { x1: 0, y1: 0, x2: 100, y2: 50, orig: "hello", trans: "bonjour" },
      { x1: 0, y1: 0, x2: 200, y2: 100, orig: "world", trans: "monde" }
    ]

    results = @calculator.calculate_batch(items)
    assert_equal 2, results.length
    assert_instance_of TextFit::Result, results.first
    assert_instance_of TextFit::Result, results.last
  end

  def test_batch_processing_with_string_keys
    items = [
      { "x1" => 0, "y1" => 0, "x2" => 100, "y2" => 50, "orig" => "hello", "trans" => "bonjour" }
    ]

    results = @calculator.calculate_batch(items)
    assert_equal 1, results.length
    assert_instance_of TextFit::Result, results.first
  end
end
