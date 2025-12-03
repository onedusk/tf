#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "text_fit"

puts "=== Custom Configuration Example ==="

# Test case: fitting longer text into a box
x1, y1, x2, y2 = 0, 0, 100, 50
original_text = "Hi"
translated_text = "Hello world, this is a much longer translation"

# Default configuration
puts "\n1. Default Configuration (delta: 0.5, min_size_factor: 0.3)"
default_config = TextFit::Configuration.default
default_calculator = TextFit::Calculator.new(config: default_config)
result = default_calculator.calculate(x1, y1, x2, y2, original_text, translated_text)
puts "   Font size: #{result.font_size.round(2)}"
puts "   Iterations: #{result.iterations}"
puts "   Fitted: #{result.fitted}"

# Fine-grained reduction (smaller delta)
puts "\n2. Fine-Grained Configuration (delta: 0.1, min_size_factor: 0.3)"
fine_config = TextFit::Configuration.new(delta: 0.1, min_size_factor: 0.3)
fine_calculator = TextFit::Calculator.new(config: fine_config)
result = fine_calculator.calculate(x1, y1, x2, y2, original_text, translated_text)
puts "   Font size: #{result.font_size.round(2)}"
puts "   Iterations: #{result.iterations}"
puts "   Fitted: #{result.fitted}"

# Higher minimum size
puts "\n3. High Minimum Configuration (delta: 0.5, min_size_factor: 0.5)"
high_min_config = TextFit::Configuration.new(delta: 0.5, min_size_factor: 0.5)
high_min_calculator = TextFit::Calculator.new(config: high_min_config)
result = high_min_calculator.calculate(x1, y1, x2, y2, original_text, translated_text)
puts "   Font size: #{result.font_size.round(2)}"
puts "   Iterations: #{result.iterations}"
puts "   Fitted: #{result.fitted}"
puts "   Minimum allowed: #{result.metadata[:minimum_size]}"

# Aggressive reduction (larger delta)
puts "\n4. Aggressive Configuration (delta: 2.0, min_size_factor: 0.2)"
aggressive_config = TextFit::Configuration.new(delta: 2.0, min_size_factor: 0.2)
aggressive_calculator = TextFit::Calculator.new(config: aggressive_config)
result = aggressive_calculator.calculate(x1, y1, x2, y2, original_text, translated_text)
puts "   Font size: #{result.font_size.round(2)}"
puts "   Iterations: #{result.iterations}"
puts "   Fitted: #{result.fitted}"

puts "\n" + "=" * 60
puts "Note: Smaller delta = more precise but more iterations"
puts "      Larger min_size_factor = prevents text from getting too small"
