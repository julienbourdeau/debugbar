module Debugbar::TagHelpers
  def debugbar_stylesheet
    raw <<-HTML
      <link rel="stylesheet" href="#{Debugbar.config.prefix}/assets/style">
      HTML
  end

  def debugbar_javascript(opt = {})
    html = <<-HTML
      <div id="__debugbar"></div>
    HTML

    html += <<-HTML
      <script type="text/javascript">
        window._debugbarConfigOptions = #{opt.to_json}
      </script>
    HTML

    html += <<-HTML
      <script defer src="#{Debugbar.config.prefix}/assets/script"></script>
      HTML

    raw html
  end
end
