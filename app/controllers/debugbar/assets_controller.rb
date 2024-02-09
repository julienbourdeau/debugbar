module Debugbar
  class AssetsController < ApplicationController
    def js
      render file: Debugbar.js_file,
        layout: false,
        content_type: 'text/javascript'
    end

    private

    def verify_same_origin_request
      true # YOLO
    end
  end
end
