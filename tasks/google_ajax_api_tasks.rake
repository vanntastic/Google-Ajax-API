ROOT_DIR = Rails.respond_to?(:root) ? Rails.root : RAILS_ROOT
JSDIR = File.join(ROOT_DIR, "public/javascripts")

namespace :gajax do
  
  desc 'Install the ajax libs local'
  task :install do
    if ENV['LIB'].nil?
      puts "EX: rake gajax:install LIB=jquery.1.3.2 (where LIB=libraryname-version)"
      puts "EX: rake gajax:install LIB=scriptaculous-1.8.2 (where LIB=libraryname-version) LIB_FILE=effects"
      puts "Get a list of all libs here : http://code.google.com/apis/ajaxlibs/documentation/index.html"
      puts "Requires curl, sorry windows people"
    else
      exceptions = %w(ext chrome yui dojo)
      lib, version = ENV['LIB'].split("-").first, ENV['LIB'].split("-")[1]
      if exceptions.include?(lib)
        puts "Library : #{ENV['LIB']} cannot be downloaded right now, please download it manually at : http://code.google.com/apis/ajaxlibs/documentation/index.html" 
      else
        lib_file = ENV['LIB_FILE'] || (lib == "jqueryui" ? "jquery-ui" : lib)
        url = File.join Google::AjaxApi::BASE_URL, lib, version, "#{lib_file}.js"
        system "curl -O #{url}"
        FileUtils.mv "#{lib_file}.js", JSDIR, :force => true
        puts "#{lib_file}.js has been installed at #{File.join(JSDIR,lib_file+'.js')}."
      end
    end
  end
  
end
