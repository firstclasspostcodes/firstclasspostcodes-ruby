# frozen_string_literal: true

DOC_URL = "https://docs.firstclasspostcodes.com/ruby/errors"

module Firstclasspostcodes
  class ResponseError < StandardError
    attr_reader :doc_url, :type

    def initialize(obj, type)
      if obj.is_a?(Hash)
        super(obj[:message])
        @doc_url = obj[:docUrl]
        @type = obj[:type]
        return
      end
      super(obj)
      @doc_url = "#{DOC_URL}/#{type}"
      @type = type
    end

    def message
      <<-MSG
        The following "#{type}" error was encountered:
          #{super}
        => See: #{doc_url}
      MSG
    end
  end
end
