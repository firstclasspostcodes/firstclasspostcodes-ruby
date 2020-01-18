# frozen_string_literal: true

$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), "lib"))

require "firstclasspostcodes/version"

REPO_URL = "github.com/firstclasspostcodes/firstclasspostcodes-ruby"

DOMAIN_NAME = "firstclasspostcodes.com"

Gem::Specification.new do |s|
  s.name = "firstclasspostcodes"

  s.version = Firstclasspostcodes::VERSION

  s.required_ruby_version = ">= 2.3.0"

  s.summary = <<-SUMMARY
    Ruby bindings for the Firstclasspostcodes API
  SUMMARY

  s.description = <<-DESC
    With 500 requests for free per month, get started with the
    fastest and cheapest address lookup service in the UK.

    See https://#{DOMAIN_NAME} for more details.
  DESC

  s.author = "Firstclasspostcodes"

  s.email = "support@#{DOMAIN_NAME}"

  s.homepage = "https://docs.#{DOMAIN_NAME}"

  s.license = "MIT"

  s.metadata = {
    "bug_tracker_uri" => "https://#{REPO_URL}/issues",
    "changelog_uri" => "https://#{REPO_URL}/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://docs.#{DOMAIN_NAME}",
    "github_repo" => "ssh://#{REPO_URL}",
    "homepage_uri" => "https://#{DOMAIN_NAME}",
    "source_code_uri" => "https://#{REPO_URL}",
  }

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n")
                                           .map { |f| ::File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "json", "~> 2.2", ">= 2.2.0"
  s.add_runtime_dependency "typhoeus", "~> 1.3", ">= 1.3.1"
end
