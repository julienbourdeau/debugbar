module DebugbarRb
  class AssetsController < ApplicationController
    def css
      render file: Assets.css,
        layout: false,
        content_type: 'text/css'
    end

    def js
      render file: Assets.js,
        layout: false,
        content_type: 'text/javascript'
    end

    private

    def verify_same_origin_request
      true # YOLO
    end
  end
end
