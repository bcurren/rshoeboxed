# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rshoeboxed/version"

Gem::Specification.new do |s|
  s.name = %q{rshoeboxed}
  s.version = RShoeboxed::VERSION 
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ben Curren"]
  s.email = ["ben@outright.com"]
  s.homepage = %q{http://github.com/jimmytang/rshoeboxed}
  s.summary = %q{Ruby wrapper for the Shoeboxed API.}
  s.description = %q{Ruby wrapper for the Shoeboxed API.}

  s.rubyforge_project = %q{rshoeboxed}

  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/rshoeboxed.rb", "lib/rshoeboxed/category.rb", "lib/rshoeboxed/connection.rb", "lib/rshoeboxed/list_proxy.rb", "lib/rshoeboxed/parse_error.rb", "lib/rshoeboxed/receipt.rb", "script/console", "script/destroy", "script/generate", "test/fixtures/category_request.xml", "test/fixtures/category_response.xml", "test/fixtures/receipt_info_request.xml", "test/fixtures/receipt_info_response.xml", "test/fixtures/receipt_request.xml", "test/fixtures/receipt_response.xml", "test/fixtures/receipt_response_bad_credentials.xml", "test/fixtures/receipt_response_internal_error.xml", "test/fixtures/receipt_response_restricted_ip.xml", "test/fixtures/receipt_response_unknown_api_call.xml", "test/fixtures/receipt_response_xml_validation.xml", "test/fixtures/receipt_with_category_id_request.xml", "test/test_category.rb", "test/test_connection.rb", "test/test_helper.rb", "test/test_list_proxy.rb", "test/test_receipt.rb"]
  s.test_files = ["test/test_category.rb", "test/test_connection.rb", "test/test_helper.rb", "test/test_list_proxy.rb", "test/test_receipt.rb"]
  s.require_paths = ["lib"]

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = %q{2010-02-15}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = %q{1.3.1}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.4"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_dependency(%q<mocha>, [">= 0.9.4"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<builder>, ["~> 2.1.2"])
    s.add_dependency(%q<newgem>, [">= 1.1.0"])
    s.add_dependency(%q<mocha>, [">= 0.9.4"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
