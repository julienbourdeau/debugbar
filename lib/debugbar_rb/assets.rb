module DebugbarRb
  class Assets
    class << self
      def js=(js)
        @js = path(js)
      end

      def js
        @js
      end

      def css=(css)
        @css = path(css)
      end

      def css
        @css
      end

      private

      def path(asset)
        File.join(Gem.loaded_specs['debugbar_rb'].full_gem_path, 'client', 'dist', asset)
      end
    end
  end
end
