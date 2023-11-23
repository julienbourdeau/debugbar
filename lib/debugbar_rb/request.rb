module DebugbarRb
  class Request
    attr_reader :request_id, :models, :queries, :meta, :request, :response
    attr_writer :request, :response

    def initialize(request_id)
      @request_id = request_id
      @models = {}
      @queries = []
      # @request = nil
      # @response = nil
      # @meta = nil
    end

    alias_method :id, :request_id

    def meta=(meta)
      meta.delete(:headers)
      meta.delete(:request)
      meta.delete(:response)
      @meta = meta
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
        id: request_id,
        meta: meta,
        models: models,
        queries: queries,
        request: request,
        response: response,
      }
    end

    def to_h
      {
        id: request_id,
        meta: meta,
        models: models,
        queries: queries,
      }
    end

    def to_json
      JSON.pretty_generate(to_h)
    end
  end
end
