lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip_watermark/version'

Gem::Specification.new do |spec|
  spec.name          = "paperclip_watermark"
  spec.version       = PaperclipWatermark::VERSION
  spec.authors       = ["Alessandro Caianiello"]
  spec.email         = ["github@caianiello.it"]
  spec.summary       = %q{Paperclip Watermark with resize support}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "paperclip", "~> 4.2"
  spec.add_development_dependency("rspec")
end
