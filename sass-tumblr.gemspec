lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "sass-tumblr"
  spec.version       = "0.3.0"
  spec.authors       = ["Yoshimasa Niwa"]
  spec.email         = ["niw@niw.at"]
  spec.homepage      = "https://github.com/niw/sass-tumblr"
  spec.description   =
  spec.summary       = "Provide SSH port forwarding while deploying"

  spec.extra_rdoc_files = `git ls-files -- README*`.split($/)
  spec.files            = `git ls-files -- lib/*`.split($/) +
                          spec.extra_rdoc_files

  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sass", "~> 3.4.22"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
