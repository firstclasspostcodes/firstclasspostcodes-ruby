# frozen_string_literal: true

require_relative "methods/list_addresses"
require_relative "methods/format_address"

module Firstclasspostcodes
  module Operations
    module GetPostcode
      def get_postcode(postcode)
        error_object = nil

        if !postcode.is_a?(String) || postcode.empty?
          error_object = {
            message: "Unexpected postcode parameter: '#{postcode}'",
            docUrl: "https://docs.firstclasspostcodes.com/operation/getPostcode",
          }
        end

        request_params = { method: :get, path: "/postcode", query_params: { search: postcode } }

        @config.logger.debug("Executing operation getPostcode: #{request_params}") if @config.debug?

        emit("operation:getPostcode", request_params)

        if error_object
          error = StandardError.new(error_object)
          @config.logger.debug("Encountered ParameterValidationError: #{error}")
          emit("error", error)
          raise error
        end

        response = request(request_params)

        response.extend(Methods::ListAddresses, Methods::FormatAddress) unless @config.geo_json?

        response
      end
    end
  end
end
