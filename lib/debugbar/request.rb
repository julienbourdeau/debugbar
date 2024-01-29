module Debugbar
  class Request
    attr_reader :request_id, :meta,
                :models, :queries, :jobs,
                :messages, :cache, :logs
    attr_accessor :request, :response, :headers

    def initialize(request_id)
      @request_id = request_id
      @models = {}
      @queries = []
      @jobs = []
      @messages = []
      @cache = []
      @logs = []
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

    def add_query(query)
      @queries << query
    end

    def add_job(job)
      @jobs << job
    end

    def add_msg(msg, extra)
      @messages << {msg: msg, extra: extra}
    end

    def add_cache(c)
      @cache << c
    end

    def add_log(l)
      @logs << l
    end

    def to_h
      {
        id: request_id,
        meta: meta,
        request: request_hash,
        response: response_hash,
        models: models,
        queries: queries,
        jobs: jobs,
        messages: messages,
        cache: cache,
        logs: logs,
      }
    end

    def to_json
      JSON.pretty_generate(to_h)
    end

    private

    def request_hash
      {
        method: request.method,
        path: request.path,
        format: meta[:format],
        params: meta[:params],
        headers: request.env.select { |k,v| k.start_with? 'HTTP_'} # https://stackoverflow.com/a/55406700/1001125
                        .transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }
                        .sort.to_h
      }
    end

    def response_hash
      return {}
      {
        status: response.status,
        headers: response.headers.to_h.transform_keys { |s| s.split('-').map(&:capitalize).join('-') },
        body: response.body,
      }
    end
  end
end
