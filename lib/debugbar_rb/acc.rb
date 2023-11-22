# frozen_string_literal: true

require 'json'

module DebugbarRb
  class Acc
    class << self
      attr_reader :request_id, :models, :queries, :meta, :request, :response
      attr_writer :meta, :request, :response

      def init(request_id)
        @request_id = request_id
        @models = {}
        @queries = []
        @request = nil
        @meta = nil
      end

      def inc_model(name)
        if @models[name]
          @models[name] += 1
        else
          @models[name] = 1
        end
      end

      def add_query(str)
        @queries << str
      end

      def dump
        {
          id: @request_id,
          meta: @meta,
          models: @models,
          queries: @queries,
          request: @request,
          response: @response,
        }
      end

      def to_json
        meta = @meta.dup
        if meta
          meta.delete(:headers)
          meta.delete(:request)
        end

        JSON.pretty_generate({
          id: @request_id,
          meta: meta,
          models: @models,
          queries: @queries,
        })
      end
    end
  end
end
