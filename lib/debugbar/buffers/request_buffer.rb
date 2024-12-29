module Debugbar
  class RequestBuffer
    class << self
      def init(adapter)
        @adapter = adapter
      end

      # Maybe making this explicit is better :D
      %w(push each all remove clear!).each do |name|
        define_method(name) do |*args, &block|
          ret = @adapter.send(name, *args, &block)
          ret == :self ? self : ret
        end
      end
    end
  end
end
