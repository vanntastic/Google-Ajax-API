BASE = "http://ajax.googleapis.com/ajax/libs/"
JSDIR = File.join(Rails.root, "public/javascripts")

namespace :gajax do
  
  desc 'Install the ajax libs locall'
  task :install do
    if ENV['LIB'].nil?
      puts "EX: rake gajax:install LIB=jquery-1.4.2 (where LIB=libraryname-version)"
      puts "Get a list of all libs here : http://code.google.com/apis/ajaxlibs/documentation/index.html"
      puts "Requires curl, sorry windows people"
    else
      exceptions = %w(ext chrome yui dojo)
      lib, version = ENV['LIB'].split("-").first, ENV['LIB'].split("-")[1]
      if exceptions.include?(lib)
        puts "Library : #{ENV['LIB']} cannot be downloaded right now, please download it manually at : http://code.google.com/apis/ajaxlibs/documentation/index.html" 
      else
        lib_file = lib == "jqueryui" ? "jquery-ui" : lib
        url = File.join BASE, lib, version, "#{lib_file}.js"
        system "curl -O #{url}"
        FileUtils.mv "#{lib_file}.js", JSDIR, :force => true
        puts "#{lib_file}.js has been installed at #{File.join(JSDIR,lib_file+'.js')}."
      end
    end
  end
  
end
