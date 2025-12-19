# frozen_string_literal: true

module TextFit
  # ============================================================================
  # Algorithm 1: Font Size Estimation and Adaptation
  # ============================================================================
  #
  # Mathematical Notation          |  Ruby Implementation
  # -------------------------------|--------------------------------------------
  # INPUT:                         |
  #   Bounding box: (x₁,y₁),(x₂,y₂)|  def calculate(x1, y1, x2, y2,
  #   Original text: t_orig        |                t_orig, t_trans)
  #   Translated text: t_trans     |
  #                                |
  # INITIAL FONT SIZE ESTIMATION:  |
  #   w = |x₂ - x₁|                |    w = (x2 - x1).abs
  #   h = |y₂ - y₁|                |    h = (y2 - y1).abs
  #   sₒ = min(w, h)               |    s_o = [w, h].min
  #   sₜ ← sₒ                       |    s_t = s_o
  #   s_min ← 0.3 · sₒ             |    s_min = config.min_size_factor * s_o
  #                                |
  # DYNAMIC FONT SIZING:           |
  #   nₒ = |t_orig|                |    n_o = t_orig.length
  #   nₜ = |t_trans|               |    n_t = t_trans.length
  #   δ ← 0.5                      |    delta = config.delta
  #   C = w·h/sₜ²                  |    capacity = (w * h) / (s_t ** 2)
  #                                |
  # IF nₜ > nₒ THEN                |    if n_t > n_o
  #   WHILE C < nₜ AND sₜ > s_min   |      while capacity < n_t && s_t > s_min
  #     sₜ ← sₜ - δ                 |        s_t = s_t - delta
  #     C ← w·h/sₜ²                 |        capacity = (w * h) / (s_t ** 2)
  #   END WHILE                    |      end
  # END IF                         |    end
  #                                |
  # RETURN sₜ                      |    return s_t
  #                                |  end
  # ============================================================================
  #
  # The algorithm in essence:
  #
  # 1. Start with font size = smaller dimension of bounding box
  # 2. Calculate how many characters fit at current font size
  # 3. If translated text doesn't fit, reduce font size iteratively
  # 4. Stop when text fits or minimum size (30% of original) is reached
  #
  # The key insight: Capacity ∝ Area / FontSize²
  # ============================================================================

  # Calculates optimal font size for fitting text into bounding boxes
  class Calculator
    attr_reader :config

    # @param config [Configuration] Configuration for the calculator
    def initialize(config: Configuration.default)
      @config = config
    end

    # Calculate optimal font size for translated text to fit in bounding box
    #
    # @param x1 [Numeric] X coordinate of top-left corner
    # @param y1 [Numeric] Y coordinate of top-left corner
    # @param x2 [Numeric] X coordinate of bottom-right corner
    # @param y2 [Numeric] Y coordinate of bottom-right corner
    # @param t_orig [String] Original text
    # @param t_trans [String] Translated text
    # @return [Result] Calculation result with font size and metadata
    def calculate(x1, y1, x2, y2, t_orig, t_trans)
      # Validate inputs
      validate_inputs!(x1, y1, x2, y2, t_orig, t_trans)

      # Initial Font Size Estimation
      w = (x2 - x1).abs                       # w = |x₂ - x₁|
      h = (y2 - y1).abs                       # h = |y₂ - y₁|
      s_o = [w, h].min                        # sₒ = min(w, h)
      s_t = s_o                               # sₜ ← sₒ
      s_min = config.min_size_factor * s_o    # s_min ← min_size_factor · sₒ

      # Dynamic Font Sizing
      n_o = t_orig.length                     # nₒ = |t_orig|
      n_t = t_trans.length                    # nₜ = |t_trans|
      delta = config.delta                    # δ ← delta
      iterations = 0
      fitted = true

      if n_t > n_o                            # if nₜ > nₒ then
        capacity = (w * h) / (s_t**2)         # C = w·h/sₜ²

        while capacity < n_t && s_t > s_min   # while C < nₜ and sₜ > s_min do
          s_t -= delta                        # sₜ ← sₜ - δ
          capacity = (w * h) / (s_t**2)       # C ← w·h/sₜ²
          iterations += 1
        end

        # Check if we hit the minimum without fitting
        fitted = capacity >= n_t
      end

      Result.new(
        font_size: s_t,
        original_size: s_o,
        iterations: iterations,
        fitted: fitted,
        metadata: {
          bounding_box: { x1: x1, y1: y1, x2: x2, y2: y2 },
          dimensions: { width: w, height: h },
          text_lengths: { original: n_o, translated: n_t },
          minimum_size: s_min
        }
      )
    end

    # Batch calculate font sizes for multiple translations
    #
    # @param items [Array<Hash>] Array of hashes with keys: x1, y1, x2, y2, t_orig, t_trans
    # @return [Array<Result>] Array of calculation results
    def calculate_batch(items)
      items.map do |item|
        calculate(
          item[:x1] || item['x1'],
          item[:y1] || item['y1'],
          item[:x2] || item['x2'],
          item[:y2] || item['y2'],
          item[:t_orig] || item['t_orig'] || item[:orig] || item['orig'],
          item[:t_trans] || item['t_trans'] || item[:trans] || item['trans']
        )
      end
    end

    private

    def validate_inputs!(x1, y1, x2, y2, t_orig, t_trans)
      raise ArgumentError, 'Coordinates must be numeric' unless [x1, y1, x2, y2].all? { |c| c.is_a?(Numeric) }
      raise ArgumentError, 'Texts must be strings' unless t_orig.is_a?(String) && t_trans.is_a?(String)
      raise ArgumentError, 'Bounding box must have positive area' if (x2 - x1).abs.zero? || (y2 - y1).abs.zero?
    end
  end
end
