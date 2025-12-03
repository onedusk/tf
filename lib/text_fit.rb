# frozen_string_literal: true

# Standard library dependencies
require "json"
require "yaml"

# Gem dependencies
require "thor"
require "zeitwerk"

# Module for font size calculation and text fitting
module TextFit
  class Error < StandardError; end

  # Configure Zeitwerk autoloader
  loader = Zeitwerk::Loader.for_gem
  loader.inflector.inflect("cli" => "CLI")
  loader.setup

  # Convenience method for quick calculations
  #
  # @param x1 [Numeric] X coordinate of top-left corner
  # @param y1 [Numeric] Y coordinate of top-left corner
  # @param x2 [Numeric] X coordinate of bottom-right corner
  # @param y2 [Numeric] Y coordinate of bottom-right corner
  # @param t_orig [String] Original text
  # @param t_trans [String] Translated text
  # @param config [Configuration] Optional configuration
  # @return [Result] Calculation result
  def self.calculate(x1, y1, x2, y2, t_orig, t_trans, config: Configuration.default)
    calculator = Calculator.new(config: config)
    calculator.calculate(x1, y1, x2, y2, t_orig, t_trans)
  end
end
