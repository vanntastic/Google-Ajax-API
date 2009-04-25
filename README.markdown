Google AJAX API
===============

Now you no longer have to manually download frameworks and manually wire them into your app this super duper simple rails plugin allows you to load js frameworks from google. You can view the list of available frameworks to use here:

      http://code.google.com/apis/ajaxlibs/documentation/
    
USAGE
=====

Just call the following method in your layout file, preferably in the head:

      <%= include_js 'framework-version' %>
    
EXAMPLES
--------
    
    LOAD JQUERY 1.3.2
    
      <%= include_js 'jquery-1.3.2' %>
    
    LOAD PROTOTYPE 1.6.0.2
    
      <%= include_js 'prototype-1.6.0.3' %>
    
    LOAD MOOTOOLS
    
      <%= include_js "mootools-1.2.1" %>

YOU CAN ALSO LOAD MULTIPLE FRAMEWORKS

    LOAD JQUERY 1.3.2 AND JQUERY UI 1.7.1
    
      <%= include_js 'jquery-1.3.2', 'jqueryui-1.7.1' %>

Copyright (c) 2009 Vann Ek, released under the MIT license
