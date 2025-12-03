# frozen_string_literal: true

module TextFit
  # Configuration for font size calculation
  class Configuration
    attr_accessor :delta, :min_size_factor

    # Default configuration values
    DEFAULT_DELTA = 0.5
    DEFAULT_MIN_SIZE_FACTOR = 0.3

    # @param delta [Float] Font size reduction step (default: 0.5)
    # @param min_size_factor [Float] Minimum size as percentage of original (default: 0.3)
    def initialize(delta: DEFAULT_DELTA, min_size_factor: DEFAULT_MIN_SIZE_FACTOR)
      @delta = delta
      @min_size_factor = min_size_factor
      validate!
    end

    # Load configuration from YAML file
    # @param path [String] Path to YAML configuration file
    # @return [Configuration]
    def self.from_file(path)
      data = YAML.load_file(path)
      new(
        delta: data["delta"] || DEFAULT_DELTA,
        min_size_factor: data["min_size_factor"] || DEFAULT_MIN_SIZE_FACTOR
      )
    end

    # Load configuration from environment variables
    # @return [Configuration]
    def self.from_env
      new(
        delta: ENV.fetch("TEXT_FIT_DELTA", DEFAULT_DELTA).to_f,
        min_size_factor: ENV.fetch("TEXT_FIT_MIN_SIZE_FACTOR", DEFAULT_MIN_SIZE_FACTOR).to_f
      )
    end

    # Default configuration
    # @return [Configuration]
    def self.default
      new
    end

    private

    def validate!
      raise ArgumentError, "delta must be positive" unless delta.positive?
      raise ArgumentError, "min_size_factor must be between 0 and 1" unless min_size_factor.between?(0, 1)
    end
  end
end
