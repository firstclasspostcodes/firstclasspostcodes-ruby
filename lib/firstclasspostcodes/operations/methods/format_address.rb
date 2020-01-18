# frozen_string_literal: true

module Firstclasspostcodes
  module Operations
    module Methods
      module FormatAddress
        def format_address(index)
          type, element = index.split(":")

          data = {
            locality: self[:city] || self[:locality],
            region: self[:county] || self[:region],
            postcode: self[:postcode],
            country: self[:country],
          }

          return data if type == "postcode"

          list = self[type.to_sym]

          index = element.to_i

          raise StandardError, `Received index "#{index}" but no #{type} data.` if list.empty?

          address = if type == "numbers"
                      component = list[index]
                      join = ->(*args) { args.compact.reject(&:empty?).join(", ") }
                      join.call(component[:number], component[:building], component[:street])
                    else
                      list[index]
                    end

          data.merge(address: address)
        end
      end
    end
  end
end
