# frozen_string_literal: true

module TextFit
  # Command-line interface for TextFit
  class CLI < Thor
    class_option :delta, type: :numeric, desc: 'Font size reduction step (default: 0.5)'
    class_option :min_size_factor, type: :numeric, desc: 'Minimum size factor (default: 0.3)'
    class_option :output_format, type: :string, enum: %w[text json yaml], default: 'text',
                                 desc: 'Output format'

    desc 'calculate X1 Y1 X2 Y2 ORIG TRANS', 'Calculate font size for text fitting'
    long_desc <<~DESC
      Calculate the optimal font size for fitting translated text into a bounding box.

      Arguments:
        X1, Y1: Coordinates of top-left corner of bounding box
        X2, Y2: Coordinates of bottom-right corner of bounding box
        ORIG: Original text
        TRANS: Translated text

      Examples:
        $ text-fit calculate 0 0 100 50 "hello" "bonjour"
        $ text-fit calculate --output-format json 0 0 200 100 "short" "much longer text"
        $ text-fit calculate --delta 0.25 --min-size-factor 0.4 0 0 100 50 "hi" "hello"
    DESC
    def calculate(x1, y1, x2, y2, orig, trans)
      config = build_config
      calculator = Calculator.new(config: config)
      result = calculator.calculate(x1.to_f, y1.to_f, x2.to_f, y2.to_f, orig, trans)
      output_result(result)
    rescue ArgumentError => e
      error("Error: #{e.message}")
    end

    desc 'batch FILE', 'Process multiple translations from JSON file'
    long_desc <<~DESC
      Process multiple text fitting calculations from a JSON file.

      The JSON file should contain an array of objects with the following structure:
      [
        {
          "x1": 0, "y1": 0, "x2": 100, "y2": 50,
          "orig": "hello", "trans": "bonjour"
        },
        ...
      ]

      Examples:
        $ text-fit batch translations.json
        $ text-fit batch --output-format json translations.json > results.json
    DESC
    def batch(file)
      unless File.exist?(file)
        error("File not found: #{file}")
        return
      end

      data = JSON.parse(File.read(file))
      config = build_config
      calculator = Calculator.new(config: config)

      results = calculator.calculate_batch(data)

      case options[:output_format]
      when 'json'
        puts JSON.pretty_generate(results.map(&:to_h))
      when 'yaml'
        puts YAML.dump(results.map(&:to_h))
      else
        results.each_with_index do |result, idx|
          puts "\n[#{idx + 1}] #{result}"
        end
      end
    rescue JSON::ParserError => e
      error("Invalid JSON: #{e.message}")
    rescue StandardError => e
      error("Error processing batch: #{e.message}")
    end

    desc 'version', 'Show version'
    def version
      puts "TextFit version #{TextFit::VERSION}"
    end

    private

    def build_config
      config_opts = {}
      config_opts[:delta] = options[:delta] if options[:delta]
      config_opts[:min_size_factor] = options[:min_size_factor] if options[:min_size_factor]

      if config_opts.empty?
        Configuration.default
      else
        Configuration.new(**config_opts)
      end
    end

    def output_result(result)
      case options[:output_format]
      when 'json'
        puts result.to_json
      when 'yaml'
        puts result.to_yaml
      else
        puts result
      end
    end

    def error(message)
      warn message
      exit 1
    end
  end
end
