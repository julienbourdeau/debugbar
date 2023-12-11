module DebugbarRb
  class MemoryBuffer
    def initialize
      @collection = {}
    end

    def push(request)
      @collection[request.id] = request
      nil
    end

    def remove(ids)
      ids = Array.wrap(ids)
      ids.each do |id|
        @collection.delete(id)
      end
      :self
    end

    def all
      @collection.values
    end

    def each(&block)
      @collection.each(&block)
      :self
    end

    def clear!
      @collection = {}
      :self
    end
  end
end
