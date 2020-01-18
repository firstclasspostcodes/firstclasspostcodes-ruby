# frozen_string_literal: true

module Firstclasspostcodes
  module Events
    def on(event_name, &handler)
      event_symbol = event_name.to_sym
      events[event_symbol] ||= []
      events[event_symbol].push(handler)
      handler.object_id
    end

    def off(event_name, handler_id)
      events[event_name.to_sym]&.filter! do |handler|
        handler.object_id != handler_id
      end
      handler_id
    end

    def emit(event_name, *args)
      events[event_name.to_sym]&.each { |handler| handler.call(*args) }
    end

    def events
      @events ||= {}
    end
  end
end
