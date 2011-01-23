specifications = Gem::Specification.new do |spec| 
  spec.name = "factory_boy"
  spec.version = "2.0.1"
  spec.author = "Philippe Cantin"
  spec.homepage = "http://github.com/anoiaque/factory_boy"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "Create fixtures for unit testing as in Factory Girl but without database usage."
  spec.description = <<-EOF
      Factory Girl with database accesses stubbed.
      The versions 2+ only work with Rails 3 (AR 3+) for stubbing queries.
      Now handle Rails 3 (only Rails 3) queries stubbing,
      Transform rail3 queries into ruby select on Plants created with factory boy.
      Example
      user = Plant(:user => 'toto', :addresses => [Plant(:address, :street => 'here')])
      User.where(:name => 'toto').where('addresses.street = 'here').joins(:addresses) will be stubbed into
      a select ruby on plants and return here, user.
      See more on github and in unit tests.
    EOF
  spec.files = Dir['lib/**/*.rb']
  spec.require_path = "lib"
  spec.test_files  = Dir['test/**/*.rb']
  spec.has_rdoc = true
  spec.extra_rdoc_files = ["README.rdoc"]
end