
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bca_statement/version"

Gem::Specification.new do |spec|
  spec.name          = "bca_statement"
  spec.version       = BcaStatement::VERSION
  spec.authors       = ["Andy Marthin"]
  spec.email         = ["mr.andymarthin@gmail.com"]

  spec.summary       = %q{A ruby wrapper for BCA Statement}
  spec.description   = %q{simple and easy to use wrapper for BCA API}
  spec.homepage      = "https://github.com/andymarthin/bca_statement"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry', '~> 0.9'

  spec.add_dependency 'model_attribute', "~> 3.1.0"
  spec.add_dependency 'rest-client', "~> 2.0.2"

end
