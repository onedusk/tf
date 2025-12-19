#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'text_fit'

# Basic usage with the convenience method
puts '=== Basic Usage ==='
result = TextFit.calculate(0, 0, 100, 50, 'hello', 'bonjour')
puts "Font size: #{result.font_size}"
puts "Fitted: #{result.fitted}"
puts "Iterations: #{result.iterations}"
puts

# Using the Calculator class
puts '=== Using Calculator Class ==='
calculator = TextFit::Calculator.new
result = calculator.calculate(0, 0, 200, 100, 'short', 'much longer translated text')
puts "Original size: #{result.original_size}"
puts "Final size: #{result.font_size}"
puts "Reduction: #{((1 - result.font_size / result.original_size) * 100).round(1)}%"
puts "Iterations: #{result.iterations}"
puts

# Accessing metadata
puts '=== Metadata ==='
puts "Bounding box: #{result.metadata[:bounding_box]}"
puts "Dimensions: #{result.metadata[:dimensions]}"
puts "Text lengths: #{result.metadata[:text_lengths]}"
puts

# Different output formats
puts '=== Output Formats ==='
result = TextFit.calculate(0, 0, 100, 50, 'hi', 'hello')
puts "String: #{result}"
puts "JSON: #{result.to_json}"
puts "Hash: #{result.to_h}"
