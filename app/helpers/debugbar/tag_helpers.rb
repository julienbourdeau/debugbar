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

    html += <<-HTML
      <script type="module">
        import sheet from '#{Debugbar.config.prefix}/assets/style' assert { type: 'css' };
        const debugbar = document.getElementById('__debugbar-shadow-root')
        document.adoptedStyleSheets = [sheet];
        debugbar.shadowRoot.adoptedStyleSheets = [sheet];
      </script>
    HTML

    raw html
  end
end
