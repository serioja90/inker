
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "inker/version"

Gem::Specification.new do |spec|
  spec.name          = "inker"
  spec.version       = Inker::VERSION
  spec.authors       = ["Groza Sergiu"]
  spec.email         = ["serioja90@gmail.com"]

  spec.summary       = %q{A Ruby gem for color manipulation.}
  spec.description   = %q{Inker is a gem wrtitten in Ruby which can be used to parse and manipulate colors.}
  spec.homepage      = "https://github.com/serioja90/inker"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  rake_version = RUBY_VERSION >= '2.7' ? '~> 13.0' :
                 RUBY_VERSION >= '2.2' ? '~> 12.0' : '~> 10.0'


  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", rake_version
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9"
end
