module Debugbar
  class AssetsController < ApplicationController
    def js
      render file: File.join(Gem.loaded_specs['debugbar'].full_gem_path, 'public', 'debugbar.js'),
        layout: false,
        content_type: 'text/javascript'
    end

    private

    def verify_same_origin_request
      true # YOLO
    end
  end
end
