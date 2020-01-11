module Firstclasspostcodes
  class Configuration
    # Defines API keys used with API Key authentications.
    #
    # @return [String] the value of the API key being used
    #
    # @example parameter name is "api_key", API key is "xxx"
    #   config.api_key['api_key'] = 'xxx'
    attr_accessor :api_key

    # Defines url host
    attr_accessor :host

    # Defines the content type requested and returned
    attr_accessor :content

    # Defines HTTP protocol to be used
    attr_accessor :protocol

    # Defines url base path
    attr_accessor :base_path

    # Defines the logger used for debugging.
    # Default to `Rails.logger` (when in Rails) or logging to STDOUT.
    #
    # @return [#debug]
    attr_accessor :logger

    def initialize
      @api_key = nil
      @host = 'api.firstclasspostcodes.com'
      @content = 'json'
      @protocol = 'https'
      @base_path = '/data'
      @logger = defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      yield(self) if block_given?
    end

    # The default Configuration object.
    def self.default
      @@default ||= Configuration.new
    end

    def configure
      yield(self) if block_given?
    end

    def protocol=(protocol)
      # remove :// from protocol
      @protocol = protocol.sub(/:\/\//, '')
    end

    def host=(host)
      # remove http(s):// and anything after a slash
      @host = host.sub(/https?:\/\//, '').split('/').first
    end

    def base_path=(base_path)
      # Add leading and trailing slashes to base_path
      @base_path = "/#{base_path}".gsub(/\/+/, '/')
      @base_path = '' if @base_path == '/'
    end

    def base_url
      "#{scheme}://#{[host, base_path].join('/').gsub(/\/+/, '/')}".sub(/\/+\z/, '')
    end
  end
end
