# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bank_payments/version'

Gem::Specification.new do |spec|
  spec.name          = "bank_payments"
  spec.version       = BankPayments::VERSION
  spec.authors       = ["Michael Litton"]
  spec.email         = ["michael.litton@apoex.se"]

  spec.summary       = "For generating payment files for various banks"
  spec.homepage      = "https://github.com/apoex/bank_payments"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to?(:metadata)
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "simplecov", "~> 0.12"

  # For IBAN validation
  spec.add_runtime_dependency "ibandit", "~> 0.11"

  # Ensure correct upcase for swedish characters. This wont be
  # needed in Ruby 2.4
  spec.add_runtime_dependency "unicode_utils", "~> 1.4"
end
