lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'valued/version'

Gem::Specification.new do |spec|
  spec.name = 'valued'
  spec.required_ruby_version = '>= 3.0.0'
  spec.version = Valued::VERSION
  spec.authors = ['Mario Mainz']
  spec.email = %w[mainz.mario@googlemail.com]

  spec.summary = 'A Ruby gem that makes it easy to create value objects.'
  spec.homepage = 'https://github.com/mmainz/valued'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mmainz/valued'

  spec.files =
    Dir.chdir(File.expand_path('..', __FILE__)) do
      `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
      end
    end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'prettier_print', '>= 1.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.80'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.38'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8'
  spec.add_development_dependency 'syntax_tree', '>= 6.1'
  spec.add_development_dependency 'syntax_tree-haml', '>= 4.0'
  spec.add_development_dependency 'syntax_tree-rbs', '>= 1.0'
end
