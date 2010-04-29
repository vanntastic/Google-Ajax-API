module Google
  module AjaxApi

    # View http://code.google.com/apis/ajaxlibs/documentation/ for list of frameworks
    # USAGE:
    # 
    #   include_js 'framework-version', options={}
    # 
    # Include a single framework:
    #   
    #   include_js 'jquery-1.3.2'
    # 
    # Just pass in :cached as the last element to 
    # include a single framework with offline cache (recommended for development):
    # 
    # First run: 
    # 
    #   rake gajax:install LIB=jquery-1.3.2 
    #   include_js 'jquery-1.3.2', :cached
    #   include_js 'jquery-1.3.2','jqueryui-1.7.1', :cached
    # 
    # Include multiple frameworks
    # 
    #   include_js 'jquery-1.3.2','jqueryui-1.7.1'
    # 
    def include_js(*frameworks)
      cached = frameworks.pop if frameworks.last == :cached
      cached = true if cached == :cached
      exceptions = %w(ext chrome)
      
      gloader = ""
      frameworks.each do |framework| 
        fw, version = framework.split("-").first, framework.split("-").last
        # make an exception for ext-core and chrome-frame
        fw = "#{framework.split('-').first}-#{framework.split('-')[1]}" if exceptions.include?(framework.split("-").first)
        gloader << "google.load('#{fw}','#{version}');"
      end
      
      offline_content = frameworks.map do |f| 
        fw = f.split("-").first == "jqueryui" ? "jquery-ui" : f.split("-").first
        # exceptions.include?(fw) ? "#{fw}-#{f.split('-')[1]}" : fw
      end
      
      js_files = offline_content.map { |e| javascript_include_tag(e) }
      
      content = '<script src="http://www.google.com/jsapi"></script>'
      content << '<script type="text/javascript" charset="utf-8">'
      content << gloader
      content << "</script>"
      
      (Rails.env == "development" && cached) ? js_files : content
    end
    
  end
end