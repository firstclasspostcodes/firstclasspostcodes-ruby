# frozen_string_literal: true

module Firstclasspostcodes
  module Operations
    module Methods
      module ListAddresses
        def list_addresses
          join = ->(*args) { args.compact.reject(&:empty?).join(", ") }

          suffix = join.call(self[:city] || self[:locality], self[:postcode])

          if self[:numbers]&.any?
            return self[:numbers].each_with_index.map do |number, i|
              %W[numbers:#{i} #{join.call(number[:number], number[:building], number[:street], suffix)}]
            end
          end

          if self[:streets]&.any?
            return self[:streets].each_with_index.map do |street, i|
              %W[streets:#{i} #{join.call(street, suffix)}]
            end
          end

          [%W[postcode:0 #{suffix}]]
        end
      end
    end
  end
end
