module Debugbar
  class HttpRequest
    attr_reader :method, :url, :headers, :body

    def initialize(method, url, headers, body)
      @method = method
      @url = url
      @headers = headers
      @body = body
    end

    def self.from_rack(rack_req)
      headers = rack_req.env.select { |k,v| k.start_with? 'HTTP_'} # https://stackoverflow.com/a/55406700/1001125
        .transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }
        .sort.to_h

      new(rack_req.method, rack_req.original_url, headers, rack_req.body)
    end

    def to_h
      { method:, url:, headers:, body: }
    end
  end

  class HttpResponse
    attr_reader :status, :headers, :body

    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @body = body
    end

    def self.from_rack(rack_res)
      return nil if rack_res.nil?

      headers = rack_res.headers.to_h.transform_keys { |s| s.split('-').map(&:capitalize).join('-') }

      new(rack_res.status, headers, rack_res.body)
    end

    def to_h
      { status:, headers:, body: }
    end
  end
end
