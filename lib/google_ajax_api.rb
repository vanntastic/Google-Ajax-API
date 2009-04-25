module GoogleAjaxApi
  
  # View http://code.google.com/apis/ajaxlibs/documentation/ for list of frameworks
  def include_js(framework,version)
    content = '<script src="http://www.google.com/jsapi"></script>'
    content << '<script type="text/javascript" charset="utf-8">'
    content << "  google.load('#{framework}','#{version}');"
    content << "</script>"
  end
  
end