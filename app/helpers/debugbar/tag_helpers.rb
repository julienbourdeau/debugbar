module Debugbar::TagHelpers
  def debugbar_head
    raw <<-HTML
      <script defer src="#{Debugbar.config.prefix}/assets/script"></script>
    HTML
  end

  def debugbar_body(opt = {})
    opt = ActiveSupport::HashWithIndifferentAccess.new(opt)

    # See https://github.com/julienbourdeau/debugbar/issues/8
    if !defined?(ActionCable) && opt[:mode].nil?
      opt[:mode] = 'poll'
    end

    html = <<-HTML
      <div id="__debugbar" data-turbo-permanent></div>
    HTML

    html += <<-HTML
      <script type="text/javascript" data-turbo-permanent>
        window._debugbarConfigOptions = #{opt.to_json}
      </script>
    HTML

    raw html
  end

  def debugbar_javascript(opt = {})
    errors = [""]
    errors << "debugbar_javascript was removed in 0.3.0."
    errors << "Please use `debugbar_head` inside <head> and `debugbar_body(opt_hash)` at the end of <body> instead."
    errors << "It was split to support Turbo Drive."
    errors << "See https://debugbar.dev/changelog/ for more information."
    errors << ""
    raise errors.join("\n")
  end
end
