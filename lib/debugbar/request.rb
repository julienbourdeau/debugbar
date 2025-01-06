module Debugbar
  class Request
    attr_reader :request_id, :meta,
                :request, :response,
                :models, :queries, :jobs,
                :messages, :cache, :logs, :http_calls

    def initialize(request_id)
      @request_id = request_id
      @models = {}
      @queries = []
      @jobs = []
      @messages = []
      @cache = []
      @logs = []
      @http_calls = []
    end

    alias_method :id, :request_id

    def meta=(meta)
      meta.delete(:headers)
      meta.delete(:request)
      meta.delete(:response)
      @meta = meta
    end

    def request=(rack_request)
      @request = HttpRequest.from_rack(rack_request)
    end

    def response=(rack_response)
      @response = HttpResponse.from_rack(rack_response)
    end

    def inc_model(name)
      if @models[name]
        @models[name] += 1
      else
        @models[name] = 1
      end
    end

    def add_query(query)
      @queries << query
    end

    def add_job(job)
      @jobs << job
    end

    def add_msg(msg, extra, source)
      @messages << {id: SecureRandom.hex(8), msg: msg, extra: extra, source: source}
    end

    def add_cache(c)
      @cache << c
    end

    def add_log(l)
      @logs << l
    end

    def add_http_call(id, request, response, extra)
      @http_calls << {
        id: id,
        request: request.to_h,
        response: response.to_h
      }.merge(extra)
    end

    def to_h
      {
        id: request_id,
        meta: meta,
        request: request.to_h,
        response: response&.to_h,
        models: models,
        queries: queries,
        jobs: jobs,
        messages: messages,
        cache: cache,
        logs: logs,
        http_calls: http_calls,
      }
    end

    def to_json
      JSON.pretty_generate(to_h)
    end
  end
end
