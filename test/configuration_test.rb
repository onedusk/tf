# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def test_default_configuration
    config = TextFit::Configuration.default
    assert_equal 0.5, config.delta
    assert_equal 0.3, config.min_size_factor
  end

  def test_custom_configuration
    config = TextFit::Configuration.new(delta: 0.25, min_size_factor: 0.4)
    assert_equal 0.25, config.delta
    assert_equal 0.4, config.min_size_factor
  end

  def test_validates_positive_delta
    assert_raises(ArgumentError) do
      TextFit::Configuration.new(delta: -0.5)
    end
  end

  def test_validates_min_size_factor_range
    assert_raises(ArgumentError) do
      TextFit::Configuration.new(min_size_factor: 1.5)
    end

    assert_raises(ArgumentError) do
      TextFit::Configuration.new(min_size_factor: -0.1)
    end
  end
end
