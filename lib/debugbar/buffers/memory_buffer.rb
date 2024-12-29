module Debugbar
  class MemoryBuffer
    def initialize
      @collection = {}
    end

    def push(request)
      @collection[request.id] = request
    end

    def remove(ids)
      ids = Array.wrap(ids)
      ids.each do |id|
        @collection.delete(id)
      end
    end

    def to_h
      @collection.values.map(&:to_h)
    end

    def each(&block)
      @collection.each(&block)
    end

    def clear!
      @collection = {}
    end
  end
end
