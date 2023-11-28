module DebugbarRb
  class AssetsController < ApplicationController
    skip_after_action :verify_same_origin_request, only: [:js]

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
  end
end
