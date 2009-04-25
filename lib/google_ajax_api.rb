module Google
  module AjaxApi

    # View http://code.google.com/apis/ajaxlibs/documentation/ for list of frameworks
    # USAGE:
    # 
    #   include_js 'framework-version'
    # 
    # Include a single framework:
    #   
    #   include_js 'jquery-1.3.2'
    # 
    # Include multiple frameworks
    # 
    #   include_js 'jquery-1.3.2','jqueryui-1.7.1'
    # 
    def include_js(*frameworks)
      gloader = ""
      frameworks.each do |framework| 
        fw, version = framework.split("-").first, framework.split("-").last
        gloader << "google.load('#{fw}','#{version}');"
      end
      content = '<script src="http://www.google.com/jsapi"></script>'
      content << '<script type="text/javascript" charset="utf-8">'
      content << gloader
      content << "</script>"
    end

  end
end