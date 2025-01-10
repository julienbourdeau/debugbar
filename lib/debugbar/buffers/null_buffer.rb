module Debugbar
  class NullBuffer
    def get
      {}
    end

    def push(_request)
    end

    def remove(_ids)
    end

    def to_h
      {}
    end

    def each
    end

    def clear!
    end
  end
end
