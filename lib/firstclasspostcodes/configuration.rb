# frozen_string_literal: true

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
    attr_reader :host

    # Defines the content type requested and returned
    attr_reader :content

    # Defines HTTP protocol to be used
    attr_reader :protocol

    # Defines url base path
    attr_reader :base_path

    # Defines the logger used for debugging.
    # Default to `Rails.logger` (when in Rails) or logging to STDOUT.
    #
    # @return [#debug]
    attr_accessor :logger

    # Set this to enable/disable debugging. When enabled (set to true), HTTP request/response
    # details will be logged with `logger.debug` (see the `logger` attribute).
    # Default to false.
    #
    # @return [true, false]
    attr_accessor :debug

    # The time limit for HTTP request in seconds.
    # Default to 0 (never times out).
    attr_accessor :timeout

    ### TLS/SSL setting
    # Set this to false to skip verifying SSL certificate when calling API from https server.
    # Default to true.
    #
    # @note Do NOT set it to false in production code, otherwise you would face multiple types of cryptographic attacks.
    #
    # @return [true, false]
    attr_accessor :verify_ssl

    ### TLS/SSL setting
    # Set this to false to skip verifying SSL host name
    # Default to true.
    #
    # @note Do NOT set it to false in production code, otherwise you would face multiple types of cryptographic attacks.
    #
    # @return [true, false]
    attr_accessor :verify_ssl_host

    ### TLS/SSL setting
    # Set this to customize the certificate file to verify the peer.
    #
    # @return [String] the path to the certificate file
    #
    # @see The `cainfo` option of Typhoeus, `--cert` option of libcurl. Related source code:
    # https://github.com/typhoeus/typhoeus/blob/master/lib/typhoeus/easy_factory.rb#L145
    attr_accessor :ssl_ca_cert

    ### TLS/SSL setting
    # Client certificate file (for client certificate)
    attr_accessor :cert_file

    ### TLS/SSL setting
    # Client private key file (for client certificate)
    attr_accessor :key_file

    def initialize
      @api_key = nil
      @debug = false
      @host = "api.firstclasspostcodes.com"
      @content = "json"
      @protocol = "https"
      @base_path = "/data"
      @timeout = 0
      @verify_ssl = true
      @verify_ssl_host = true
      @cert_file = nil
      @key_file = nil
      @logger = defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      yield(self) if block_given?
    end

    # The default Configuration object.
    def self.default
      @default ||= Configuration.new
    end

    def configure
      yield(self) if block_given?
    end

    def debug?
      debug
    end

    def geo_json?
      content == "geo+json"
    end

    def content=(content)
      raise StandardError, `"#{content}" is not a valid content-type` unless %w[json geo+json].include?(content)

      @content = content
    end

    def protocol=(protocol)
      # remove :// from protocol
      @protocol = protocol.sub(%r{://}, "")
    end

    def host=(host)
      # remove http(s):// and anything after a slash
      @host = host.sub(%r{https?://}, "").split("/").first
    end

    def base_path=(base_path)
      # Add leading and trailing slashes to base_path
      @base_path = "/#{base_path}".gsub(%r{/+}, "/")
      @base_path = "" if @base_path == "/"
    end

    def base_url
      path = [host, base_path].join("/").gsub(%r{/+}, "/")
      "#{protocol}://#{path}".sub(%r{/+\z}, "")
    end

    def to_request_params
      params = {
        headers: {
          'x-api-key': api_key,
          accept: "application/#{content}; q=1.0, application/json; q=0.5",
        },
        timeout: timeout,
        ssl_verifypeer: verify_ssl,
        ssl_verifyhost: verify_ssl_host ? 2 : 0,
        sslcert: cert_file,
        sslkey: key_file,
        verbose: debug,
      }

      params[:cainfo] = ssl_ca_cert if ssl_ca_cert

      params
    end
  end
end
