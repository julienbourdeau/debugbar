module Debugbar
  class CacheBuffer
    def push(request)
      collection = get_collection
      collection[request.id] = request.to_h
      set_collection(collection)
    end

    def remove(ids)
      ids = Array.wrap(ids)

      collection = get_collection
      ids.each do |id|
        collection.delete(id)
      end
      set_collection(collection)
    end

    def to_h
      get_collection.values.map(&:to_h)
    end

    def each(&block)
      get_collection.each(&block)

    end

    def clear!
      Rails.cache.delete("debugbar-requests")
    end

    private

    def get_collection
      Rails.cache.fetch("debugbar-requests") { {} }
    end

    def set_collection(collection)
      Rails.cache.write("debugbar-requests", collection)
    end
  end
end
