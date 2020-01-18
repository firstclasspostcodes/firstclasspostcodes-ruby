# frozen_string_literal: true

module Firstclasspostcodes
  module Operations
    module GetLookup
      def get_lookup(params)
        raise StandError, "Expected hash, received: #{params}" unless params.is_a?(Hash)

        error_object = nil

        parse_f = ->(val) { val.to_f.to_s == val ? val.to_f : nil }

        within = ->(lat, lng) { (lat >= -90 && lat <= 90) && (lng >= -180 && lng <= 180) }

        unless params[:latitude] || params[:longitude]
          error_object = {
            message: "Missing required parameters, expected { latitude, longitude }.",
            docUrl: "https://docs.firstclasspostcodes.com/operation/getLookup",
          }
        end

        latitude = parse_f.call(params[:latitude])
        longitude = parse_f.call(params[:longitude])
        radius = parse_f.call(params[:radius]) || 0.1

        query_params =  { latitude: latitude, longitude: longitude, radius: radius }

        unless latitude && longitude && within.call(latitude, longitude)
          error_object = {
            message: "Parameter is invalid: #{query_params}",
            docUrl: "https://docs.firstclasspostcodes.com/operation/getLookup",
          }
        end

        request_params = { path: "/lookup", method: :get, query_params: query_params }

        @config.logger.debug("Executing operation getLookup: #{request_params}") if @config.debug?

        emit("operation:getLookup", request_params)

        if error_object
          error = StandardError.new(error_object)
          @config.logger.debug("Encountered ParameterValidationError: #{error}")
          emit("error", error)
          raise error
        end

        request(request_params)
      end
    end
  end
end
