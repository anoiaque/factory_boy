specifications = Gem::Specification.new do |spec| 
  spec.name = "factory_boy"
  spec.version = "1.0"
  spec.author = "Philippe Cantin"
  spec.homepage = "http://github.com/anoiaque/factory_boy"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "Create fixtures for unit testing as in Factory Girl but without database usage."
  spec.description = "Factory Girl with database accesses stubbed"
  spec.files = Dir['lib/**/*.rb']
  spec.require_path = "lib"
  spec.test_files  = Dir['test/**/*.rb']
  spec.has_rdoc = false
  spec.extra_rdoc_files = ["README.rdoc"]
end