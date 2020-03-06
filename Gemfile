# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development, :test do
  gem "codecov", require: false
  gem "coveralls", require: false
  gem "rake"
  gem "rspec"

  # Rubocop changes pretty quickly: new cops get added and old cops change
  # names or go into new namespaces. This is a library and we don't have
  # `Gemfile.lock` checked in, so to prevent good builds from suddenly going
  # bad, pin to a specific version number here. Try to keep this relatively
  # up-to-date, but it's not the end of the world if it's not.
  gem "rubocop", "0.80.1", require: false

  platforms :mri do
    gem "byebug"
    gem "pry"
    gem "pry-byebug"
  end
end
