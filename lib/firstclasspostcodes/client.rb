# frozen_string_literal: true

require "json"
require "typhoeus"

require "firstclasspostcodes/response_error"

module Firstclasspostcodes
  class Client
    # The Configuration object holding settings to be used in the API client.
    attr_accessor :config

    # The User-agent for the library
    attr_reader :user_agent

    # @option config [Configuration] Configuration for initializing the object
    def initialize(config = Configuration.default)
      @config = config
      @user_agent = "Firstclasspostcodes/ruby@#{Firstclasspostcodes::VERSION}"
      on("request") { |req| @config.logger.debug(req) if @config.debug }
      on("response") { |req| @config.logger.debug(req) if @config.debug }
      on("error") { |req| @config.logger.error(req) }
    end

    def request(opts)
      url = build_request_url(opts[:path])

      request_params = {
        params: opts[:query_params] || {},
        method: opts[:method].to_sym.downcase,
      }

      request_params.merge!(@config.to_request_params)

      emit("request", request_params)

      response = call_request(url, request_params)

      data = JSON.parse(response.body, symbolize_names: true)

      emit("response", data)

      data
    rescue ResponseError => e
      emit("error", e)
      raise e
    end

    def call_request(*args)
      response = Typhoeus::Request.new(*args).run

      return response if response.success?

      raise handle_request_error(response)
    end

    def handle_request_error(response)
      raise ResponseError.new("Connection timed out", "timeout") if response.timed_out?

      raise ResponseError.new(response.return_message, "liberror") if response.code == 0

      error = begin
                JSON.parse(response.body, symbolize_names: true)
              rescue JSON::ParserError
                response.body
              end

      raise ResponseError.new(error, "network-error")
    end

    def build_request_url(path)
      # Add leading and trailing slashes to path
      path = "/#{path}".gsub(%r{/+}, "/")
      @config.base_url + path
    end

    def self.default
      @default ||= Client.new
    end
  end
end
