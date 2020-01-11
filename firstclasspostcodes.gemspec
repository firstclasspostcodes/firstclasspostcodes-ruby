# frozen_string_literal: true

$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), "lib"))

require "firstclasspostcodes/version"

Gem::Specification.new do |s|
  s.name = "firstclasspostcodes"

  s.version = Firstclasspostcodes::VERSION

  s.required_ruby_version = ">= 2.3.0"

  s.summary = "Ruby bindings for the Firstclasspostcodes API"
  
  s.description = "With 500 requests for free per month, get started with the fastest and cheapest address lookup service in the UK. " \
                  "See https://firstclasspostcodes.com for more details."
  
  s.author = "Firstclasspostcodes"
  
  s.email = "support@firstclasspostcodes.com"
  
  s.homepage = "https://docs.firstclasspostcodes.com"
  
  s.license = "MIT"

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/firstclasspostcodes/firstclasspostcodes-ruby/issues",
    "changelog_uri" => "https://github.com/firstclasspostcodes/firstclasspostcodes-ruby/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://docs.firstclasspostcodes.com",
    "github_repo" => "ssh://github.com/firstclasspostcodes/firstclasspostcodes-ruby",
    "homepage_uri" => "https://firstclasspostcodes.com",
    "source_code_uri" => "https://github.com/firstclasspostcodes/firstclasspostcodes-ruby",
  }

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n")
                                           .map { |f| ::File.basename(f) }
  s.require_paths = ["lib"]
end