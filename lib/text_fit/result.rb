# frozen_string_literal: true

module TextFit
  # Represents the result of a font size calculation
  class Result
    attr_reader :font_size, :original_size, :iterations, :fitted, :metadata

    # @param font_size [Float] The calculated font size
    # @param original_size [Float] The initial font size before adaptation
    # @param iterations [Integer] Number of iterations taken to fit the text
    # @param fitted [Boolean] Whether the text successfully fit within constraints
    # @param metadata [Hash] Additional metadata about the calculation
    def initialize(font_size:, original_size:, iterations:, fitted:, metadata: {})
      @font_size = font_size
      @original_size = original_size
      @iterations = iterations
      @fitted = fitted
      @metadata = metadata
    end

    # Convert result to hash
    # @return [Hash]
    def to_h
      {
        font_size: font_size,
        original_size: original_size,
        iterations: iterations,
        fitted: fitted,
        metadata: metadata
      }
    end

    # Convert result to JSON
    # @return [String]
    def to_json(*_args)
      JSON.generate(to_h)
    end

    # Convert result to YAML
    # @return [String]
    def to_yaml
      YAML.dump(to_h)
    end

    # Human-readable string representation
    # @return [String]
    def to_s
      status = fitted ? 'fitted' : 'did not fit (reached minimum)'
      "Font size: #{font_size.round(2)} (#{status} after #{iterations} iterations)"
    end
  end
end
