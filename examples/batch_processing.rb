#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "text_fit"

puts "=== Batch Processing Example ==="

# Define multiple translations
translations = [
  { x1: 0, y1: 0, x2: 100, y2: 50, orig: "Hello", trans: "Bonjour" },
  { x1: 0, y1: 0, x2: 150, y2: 75, orig: "World", trans: "Monde" },
  { x1: 0, y1: 0, x2: 200, y2: 100, orig: "Good morning", trans: "Bonjour" },
  { x1: 0, y1: 0, x2: 80, y2: 40, orig: "Hi", trans: "Salut" },
  { x1: 0, y1: 0, x2: 120, y2: 60, orig: "Goodbye", trans: "Au revoir" }
]

# Process all at once
calculator = TextFit::Calculator.new
results = calculator.calculate_batch(translations)

# Display results
puts "\nResults:"
puts "-" * 80

results.each_with_index do |result, idx|
  translation = translations[idx]
  puts "\n[#{idx + 1}] #{translation[:orig]} → #{translation[:trans]}"
  puts "    Bounding box: (#{translation[:x1]},#{translation[:y1]}) to (#{translation[:x2]},#{translation[:y2]})"
  puts "    Font size: #{result.font_size.round(2)} (#{result.iterations} iterations)"
  puts "    Status: #{result.fitted ? '✓ Fitted' : '✗ Did not fit'}"
end

puts "\n" + "-" * 80

# Summary statistics
total_iterations = results.sum(&:iterations)
avg_font_size = (results.sum(&:font_size) / results.length).round(2)
fitted_count = results.count(&:fitted)

puts "\nSummary:"
puts "  Total translations: #{results.length}"
puts "  Successfully fitted: #{fitted_count} (#{(fitted_count.to_f / results.length * 100).round(1)}%)"
puts "  Average font size: #{avg_font_size}"
puts "  Total iterations: #{total_iterations}"
