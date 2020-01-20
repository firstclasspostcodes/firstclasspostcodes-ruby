![Cover](/.github/images/cover.png)

# Firstclasspostcodes
The Firstclasspostcodes Ruby library provides convenient access to the Firstclasspostcodes API from applications written in the Ruby language. It includes pre-defined methods and helpers to help you easily integrate the library into any application.

The library also provides other features. For example:

* Easy configuration path for fast setup and use.
* Helpers for listing and formatting addresses.
* Built-in methods for easily interacting with the Firstclasspostcodes API.

## Documentation
See [Ruby API docs](https://docs.firstclasspostcodes.com/ruby/getting-started) for detailed usage and examples.

## Installation
You don't need this source code unless you want to modify the gem. If you just want to use the package, just run:

```
gem install firstclasspostcodes
```

Or alternatively, install from the GitHub package registry:

```
gem install firstclasspostcodes --source "https://rubygems.pkg.github.com/firstclasspostcodes"
```

If you want to build the gem from source:

```
gem build firstclasspostcodes.gemspec
```

## Requirements

* Ruby 2.3+
* An API key from [https://firstclasspostcodes.com](https://firstclasspostcodes.com)

## Bundler

If you are installing via bundler, you should be sure to use the https rubygems source in your Gemfile, as any gems fetched over http could potentially be compromised in transit and alter the code of gems fetched securely over https:

```ruby
source 'https://rubygems.org'

gem 'rails'
gem 'firstclasspostcodes'
```

We also host this gem on the [GitHub Package Registry](https://github.com/firstclasspostcodes/firstclasspostcodes-ruby/packages/108443):

```ruby
source "https://rubygems.pkg.github.com/firstclasspostcodes" do
  gem "firstclasspostcodes", "0.0.1"
end
```

## Usage
Once you have configured the library, initialise a client and start calling the API.

```ruby
require 'firstclasspostcodes'
require 'json'

Firstclasspostcodes.configure do |c|
  c.api_key = 'sw34567ujbvcd'
end

client = Firstclasspostcodes::Client.new

response = client.get_postcode('SW13 6HY')

puts JSON.pretty_generate(response)
```

## Configuration
The library can be configured with several options depending on the requirements of your setup:

```ruby
require 'firstclasspostcodes'

API_KEY = 'werthj75rtfgds'

Firstclasspostcodes.configure do |c|
  # The API Key to be used when sending requests to the 
  # Firstclasspostcodes API
  c.api_key = API_KEY

  # The host to send API requests to. This is typically changed
  # to use the mock service for testing purposes
  c.host = "api.firstclasspostcodes.com"
  
  # The default content type is json, but can be changed to "geo+json"
  # to return responses as GeoJSON content type
  c.content = "json"

  # Typically, always HTTPS, but useful to change for testing
  # purposes
  c.protocol = "https"

  # The base path is "/data", but useful to change for testing
  # purposes
  c.base_path = "/data"
  
  # The default logger being used with the library. This defaults
  # to the Rails logger (if it is available)
  c.logger = Logger.new(STDOUT)

  # Output helpful debug statements to STDOUT
  c.debug = false

  # The default request timeout for the library.
  c.timeout = 30
end
```

## Events
You can subscribe to events using an initialized client, using the Ruby block pattern.

```ruby
require 'firstclasspostcodes'
require 'json'

client = Firstclasspostcodes::Client.new

client.on(:request) do |request_params|
  puts JSON.pretty_generate(request_params)
end
```

| Event name | Description |
|:-----|:-----|
| `request` | Triggered before a request is sent. The request object to be sent is passed to the event handler. |
| `response` | Triggered with the parsed JSON response body upon a successful reques. |
| `error` | Triggered with a client error when the request fails. |
| `operation:{name}` | Triggered by an operation with the parameter object. |

**Note:** `{name}` is replaced with the operation name of the method, as defined inside the OpenAPI specification.

## Debugging
Debugging through logging can be enabled inside the configuration (demonstrated below). A custom logger can also be assigned if required.

```ruby
require 'firstclasspostcodes'
require 'logger'

custom_logger = Logger.new(STDOUT)
custom_logger.level = Logger::DEBUG

Firstclasspostcodes.configure do |c|
  c.debug = true
  c.logger = custom_logger
end
```

## Integration / Testing
We provide a mock service of our API as a docker container [available here](https://github.com/firstclasspostcodes/firstclasspostcodes-mock). Once the container is running, the library can be easily configured to use it:

```ruby
require "firstclasspostcodes"
require "uri"

MOCK_API_URL = "http://localhost:3000"

MOCK_API_KEY = "111111111111"

uri = URI.parse(MOCK_API_URL)

Firstclasspostcodes.configure do |c|
  # The mock API key is always 111111111111 ("12x1")
  c.api_key = MOCK_API_KEY
  
  # Alter the configuration to use the mock service
  c.base_path = uri.path
  c.protocol = uri.scheme
  c.host = uri.host
  c.host = "#{uri.host}:#{uri.port}" if uri.port
end
```