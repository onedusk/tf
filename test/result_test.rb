# frozen_string_literal: true

require 'test_helper'

class ResultTest < Minitest::Test
  def setup
    @result = TextFit::Result.new(
      font_size: 42.5,
      original_size: 50.0,
      iterations: 3,
      fitted: true,
      metadata: { test: 'value' }
    )
  end

  def test_attributes
    assert_equal 42.5, @result.font_size
    assert_equal 50.0, @result.original_size
    assert_equal 3, @result.iterations
    assert @result.fitted
    assert_equal({ test: 'value' }, @result.metadata)
  end

  def test_to_h
    hash = @result.to_h
    assert_equal 42.5, hash[:font_size]
    assert_equal 50.0, hash[:original_size]
    assert_equal 3, hash[:iterations]
    assert hash[:fitted]
    assert_equal({ test: 'value' }, hash[:metadata])
  end

  def test_to_json
    json = @result.to_json
    assert_instance_of String, json
    parsed = JSON.parse(json)
    assert_equal 42.5, parsed['font_size']
  end

  def test_to_yaml
    yaml = @result.to_yaml
    assert_instance_of String, yaml
    assert_includes yaml, 'font_size'
  end

  def test_to_s_when_fitted
    str = @result.to_s
    assert_includes str, '42.5'
    assert_includes str, 'fitted'
    assert_includes str, '3 iterations'
  end

  def test_to_s_when_not_fitted
    result = TextFit::Result.new(
      font_size: 15.0,
      original_size: 50.0,
      iterations: 10,
      fitted: false
    )
    str = result.to_s
    assert_includes str, 'did not fit'
  end
end
