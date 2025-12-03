# TextFit Quick Start Guide

## Installation Across Projects

### Option 1: Install from Local Path (Development)

Add to your project's `Gemfile`:

```ruby
gem 'text_fit', path: '/path/to/text_fit'
```

Or install locally:

```bash
cd /path/to/text_fit
bundle exec rake install
```

### Option 2: Build and Install as Gem

```bash
# Build the gem
cd /path/to/text_fit
bundle exec rake build

# Install the built gem
gem install pkg/text_fit-0.1.0.gem

# Or use in Gemfile with local gem server
gem 'text_fit', '0.1.0', source: 'file:///path/to/text_fit/pkg'
```

### Option 3: Publish to RubyGems (Production)

```bash
# Set up RubyGems credentials (first time only)
gem login

# Build and push to RubyGems
bundle exec rake release
```

Then in any project:

```ruby
# Gemfile
gem 'text_fit', '~> 0.1.0'
```

## Quick Usage

### Command Line

```bash
# Basic calculation
text-fit calculate 0 0 100 50 "hello" "bonjour"

# JSON output
text-fit calculate --output-format json 0 0 100 50 "hi" "hello"

# Batch processing
text-fit batch translations.json

# Custom configuration
text-fit calculate --delta 0.25 --min-size-factor 0.4 0 0 100 50 "hi" "hello"
```

### Ruby Code

```ruby
require 'text_fit'

# Quick calculation
result = TextFit.calculate(0, 0, 100, 50, "hello", "bonjour")
puts result.font_size

# With custom configuration
config = TextFit::Configuration.new(delta: 0.25, min_size_factor: 0.4)
calculator = TextFit::Calculator.new(config: config)
result = calculator.calculate(0, 0, 100, 50, "hello", "bonjour")

# Batch processing
items = [
  { x1: 0, y1: 0, x2: 100, y2: 50, orig: "hello", trans: "bonjour" },
  { x1: 0, y1: 0, x2: 200, y2: 100, orig: "world", trans: "monde" }
]
results = calculator.calculate_batch(items)
```

## Common Use Cases

### 1. PDF Text Rendering

```ruby
require 'text_fit'

# Calculate font size for PDF text box
bbox = { x1: 50, y1: 100, x2: 300, y2: 150 }
result = TextFit.calculate(
  bbox[:x1], bbox[:y1], bbox[:x2], bbox[:y2],
  "Original text",
  "Translated text that might be longer"
)

# Use result.font_size in your PDF renderer
pdf.text_box(translated_text, at: [bbox[:x1], bbox[:y1]], size: result.font_size)
```

### 2. Image Text Overlay

```ruby
require 'text_fit'
require 'rmagick'

image = Magick::Image.read('template.png').first
result = TextFit.calculate(0, 0, image.columns, image.rows/2, "Short", "Much longer translation")

# Draw text with calculated font size
draw = Magick::Draw.new
draw.pointsize = result.font_size
draw.text(10, 30, "Much longer translation")
draw.draw(image)
```

### 3. UI Layout Calculations

```ruby
require 'text_fit'

# Calculate font sizes for responsive UI
labels = {
  "Login" => "Se connecter",
  "Submit" => "Soumettre le formulaire",
  "Cancel" => "Annuler"
}

button_width = 120
button_height = 40

labels.each do |orig, trans|
  result = TextFit.calculate(0, 0, button_width, button_height, orig, trans)
  puts "#{trans}: #{result.font_size}px"
end
```

### 4. Bulk Translation Processing

```bash
# Create JSON with translations
cat > translations.json << EOF
[
  {"x1": 0, "y1": 0, "x2": 100, "y2": 50, "orig": "Hello", "trans": "Bonjour"},
  {"x1": 0, "y1": 0, "x2": 200, "y2": 100, "orig": "World", "trans": "Monde"}
]
EOF

# Process batch and save results
text-fit batch --output-format json translations.json > results.json
```

## Development

```bash
# Clone/navigate to gem directory
cd /path/to/text_fit

# Install dependencies
bundle install

# Run tests
bundle exec rake test

# Build gem
bundle exec rake build

# Install locally
bundle exec rake install
```

## Tips

1. **Smaller delta = more precise results** but takes more iterations
2. **Larger min_size_factor = prevents text from becoming too small**
3. Use JSON output for automation pipelines
4. Use batch processing for large translation sets
5. Cache results for repeated calculations with same parameters

## Troubleshooting

**Issue**: Gem not found
```bash
# Make sure it's installed
gem list text_fit

# Or check Gemfile.lock
bundle list | grep text_fit
```

**Issue**: Different results between CLI and Ruby API
- Both use the same algorithm - check your configuration values

**Issue**: Text still doesn't fit
- Check the `fitted` property in the result
- Text might be too long for the box even at minimum size
- Consider using a larger `min_size_factor` or bigger bounding box
