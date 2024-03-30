module Debugbar::TagHelpers
  def debugbar_javascript(opt = {})
    opt = ActiveSupport::HashWithIndifferentAccess.new(opt)

    # See https://github.com/julienbourdeau/debugbar/issues/8
    if !defined?(ActionCable) && opt[:mode].nil?
      opt[:mode] = 'poll'
    end

    raw(<<~HTML)
      <div id="__debugbar" data-turbo-permanent></div>
      <script type="text/javascript">
        window._debugbarConfigOptions = #{opt.to_json}
      </script>
      <script defer src="#{Debugbar.config.prefix}/assets/script"></script>
    HTML
  end
end
