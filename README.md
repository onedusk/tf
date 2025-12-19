# TextFit

Calculate optimal font sizes for fitting text into bounding boxes. Perfect for UI layouts, PDF generation, image text rendering, and translation workflows.

## Algorithm

TextFit implements a mathematical algorithm for dynamic font size adaptation:

1. **Initial Estimation**: Start with font size = smaller dimension of bounding box
2. **Capacity Calculation**: Calculate how many characters fit at current font size using the formula: `Capacity ∝ Area / FontSize²`
3. **Iterative Reduction**: If translated text doesn't fit, reduce font size iteratively
4. **Minimum Threshold**: Stop when text fits or minimum size (default: 30% of original) is reached

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'text_fit'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install text_fit
```

## Usage

### Command Line Interface

#### Basic Usage

```bash
# Calculate font size for a simple translation
$ text-fit calculate 0 0 100 50 "hello" "bonjour"
Font size: 50.0 (fitted after 0 iterations)

# With JSON output
$ text-fit calculate --output-format json 0 0 100 50 "hi" "hello world"
{
  "font_size": 42.5,
  "original_size": 50.0,
  "iterations": 15,
  "fitted": true,
  "metadata": {
    "bounding_box": {"x1": 0, "y1": 0, "x2": 100, "y2": 50},
    "dimensions": {"width": 100, "height": 50},
    "text_lengths": {"original": 2, "translated": 11},
    "minimum_size": 15.0
  }
}
```

#### Configuration Options

```bash
# Custom delta (font size reduction step)
$ text-fit calculate --delta 0.25 0 0 100 50 "hi" "hello"

# Custom minimum size factor
$ text-fit calculate --min-size-factor 0.4 0 0 100 50 "hi" "hello"

# YAML output
$ text-fit calculate --output-format yaml 0 0 100 50 "hi" "hello"
```

#### Batch Processing

Create a JSON file with multiple translations:

```json
[
  {
    "x1": 0, "y1": 0, "x2": 100, "y2": 50,
    "orig": "hello", "trans": "bonjour"
  },
  {
    "x1": 0, "y1": 0, "x2": 200, "y2": 100,
    "orig": "world", "trans": "monde"
  }
]
```

Process the batch:

```bash
$ text-fit batch translations.json

[1] Font size: 50.0 (fitted after 0 iterations)
[2] Font size: 100.0 (fitted after 0 iterations)

# With JSON output
$ text-fit batch --output-format json translations.json > results.json
```

### Ruby API

#### Basic Usage

```ruby
require 'text_fit'

# Quick calculation with defaults
result = TextFit.calculate(0, 0, 100, 50, "hello", "bonjour")
puts result.font_size      # => 50.0
puts result.fitted         # => true
puts result.iterations     # => 0
```

#### Using the Calculator Class

```ruby
# Create calculator with default configuration
calculator = TextFit::Calculator.new

# Calculate font size
result = calculator.calculate(0, 0, 100, 50, "hi", "hello world")
puts result.font_size      # => 42.5
puts result.iterations     # => 15
puts result.fitted         # => true

# Access metadata
puts result.metadata[:dimensions]      # => {:width=>100, :height=>50}
puts result.metadata[:text_lengths]    # => {:original=>2, :translated=>11}
```

#### Custom Configuration

```ruby
# Create custom configuration
config = TextFit::Configuration.new(
  delta: 0.25,              # Smaller reduction steps (default: 0.5)
  min_size_factor: 0.4      # Larger minimum size (default: 0.3)
)

# Use custom configuration
calculator = TextFit::Calculator.new(config: config)
result = calculator.calculate(0, 0, 100, 50, "hi", "hello world")
```

#### Batch Processing

```ruby
items = [
  { x1: 0, y1: 0, x2: 100, y2: 50, orig: "hello", trans: "bonjour" },
  { x1: 0, y1: 0, x2: 200, y2: 100, orig: "world", trans: "monde" }
]

calculator = TextFit::Calculator.new
results = calculator.calculate_batch(items)

results.each_with_index do |result, idx|
  puts "[#{idx + 1}] Font size: #{result.font_size}"
end
```

#### Result Object

```ruby
result = TextFit.calculate(0, 0, 100, 50, "hello", "bonjour")

# Attributes
result.font_size        # Final calculated font size
result.original_size    # Initial font size estimate
result.iterations       # Number of reduction iterations
result.fitted           # Boolean: did the text fit?
result.metadata         # Hash with additional details

# Output formats
result.to_h             # Hash representation
result.to_json          # JSON string
result.to_yaml          # YAML string
result.to_s             # Human-readable string
```

## Configuration

### Environment Variables

```bash
export TEXT_FIT_DELTA=0.25
export TEXT_FIT_MIN_SIZE_FACTOR=0.4
```

```ruby
config = TextFit::Configuration.from_env
```

### Configuration File

Create `.text-fit.yml`:

```yaml
delta: 0.25
min_size_factor: 0.4
```

```ruby
config = TextFit::Configuration.from_file('.text-fit.yml')
```

## Examples

See the `examples/` directory for additional usage examples:

- `examples/basic_usage.rb` - Simple Ruby API usage
- `examples/batch_processing.rb` - Processing multiple translations
- `examples/custom_config.rb` - Using custom configurations
- `examples/translations.json` - Sample batch input file

## Mathematical Details

### Font Size Estimation Algorithm

```
INPUT:
  Bounding box: (x₁,y₁),(x₂,y₂)
  Original text: t_orig
  Translated text: t_trans

INITIAL FONT SIZE ESTIMATION:
  w = |x₂ - x₁|
  h = |y₂ - y₁|
  sₒ = min(w, h)
  sₜ ← sₒ
  s_min ← 0.3 · sₒ

DYNAMIC FONT SIZING:
  nₒ = |t_orig|
  nₜ = |t_trans|
  δ ← 0.5
  C = w·h/sₜ²

IF nₜ > nₒ THEN
  WHILE C < nₜ AND sₜ > s_min
    sₜ ← sₜ - δ
    C ← w·h/sₜ²
  END WHILE
END IF

RETURN sₜ
```

The key insight: **Capacity ∝ Area / FontSize²**

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/onedusk/tf.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
