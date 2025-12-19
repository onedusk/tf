# frozen_string_literal: true

require_relative 'lib/text_fit/version'

Gem::Specification.new do |spec|
  spec.name = 'text_fit'
  spec.version = TextFit::VERSION
  spec.authors = ['onedusk']
  spec.email = ['one@dusk-labs.com']

  spec.summary = 'Calculate optimal font sizes for fitting text into bounding boxes'
  spec.description = <<~DESC
    TextFit implements a mathematical algorithm for calculating optimal font sizes
    when fitting translated text into fixed bounding boxes. Useful for UI layouts,
    PDF generation, image text rendering, and translation workflows.
  DESC
  spec.homepage = 'https://github.com/onedusk/text_fit'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/onedusk/text_fit'
  spec.metadata['changelog_uri'] = 'https://github.com/onedusk/text_fit/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(['git', 'ls-files', '-z'], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?('bin/', 'test/', 'spec/', 'features/', '.git', 'appveyor', 'Gemfile')
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Dependencies
  spec.add_dependency 'thor', '~> 1.3'
  spec.add_dependency 'zeitwerk', '~> 2.6'

  # Metadata
  spec.metadata['rubygems_mfa_required'] = 'true'
end
