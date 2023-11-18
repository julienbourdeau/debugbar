# frozen_string_literal: true

require 'json'

module DebugbarRb
  class Acc
    class << self
      def init(request_id)
        @request_id = request_id
        @models = {}
        @queries = []
        @request = nil
      end

      def meta(meta)
        @meta = meta
      end

      def request(req)
        @request = req
      end

      def response(res)
        @response = res
      end

      def model(name)
        if @models[name]
          @models[name] += 1
        else
          @models[name] = 1
        end
      end

      def query(str)
        @queries << str
      end

      def debug(event)
        @debug = event
      end

      def dump
        {
          id: @request_id,
          meta: @meta,
          models: @models,
          queries: @queries,
          request: @request,
          response: @response,
          debug: @debug,
        }
      end

      def to_json
        JSON.dump({
          id: @request_id,
          meta: @meta,
          models: @models,
          queries: @queries,
        })
      end
    end
  end
end
