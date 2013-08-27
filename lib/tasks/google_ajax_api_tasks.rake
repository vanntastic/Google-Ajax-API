Dir.glob("#{File.dirname(__FILE__) + '/../lib'}/*.rb").each {|f| require(f)}

namespace :gajax do
  ROOT_DIR = Rails.respond_to?(:root) ? Rails.root : RAILS_ROOT
  PUBLIC_DIR = File.join(ROOT_DIR, "public")

  desc 'Install the ajax libs local'
  task :install, [:lib_dash_version, :lib_file] do |t, args|
    args.with_defaults(:lib_dash_version => nil, :lib_file => nil)
    lib_dash_version = args[:lib_dash_version]
    lib_file = args[:lib_file]

    if !lib_dash_version
      puts "EX: rake gajax:install[jquery.1.3.2] #format: libraryname-version"
      puts "EX: rake gajax:install[scriptaculous-1.8.2,effects] # where 'effects' represents the lib_file name"
      puts "Get a list of all libs here : http://code.google.com/apis/ajaxlibs/documentation/index.html"
      puts "Requires curl, sorry windows people"
    else
      exceptions = %w(ext chrome yui dojo)
      lib, version = lib_dash_version.split("-").first, lib_dash_version.split("-")[1]
      if exceptions.include?(lib)
        puts "Library : #{lib_dash_version} cannot be downloaded right now, please download it manually at : http://code.google.com/apis/ajaxlibs/documentation/index.html"
      else
        lib_file ||= Google::AjaxApi.framework_lib_to_filename(lib)
        url = File.join Google::AjaxApi::BASE_URL, lib, version, "#{lib_file}.js"
        system "curl -O #{url}"
        dest_dir = File.join(PUBLIC_DIR, Google::AjaxApi.versioned_dir(lib, version))
        FileUtils.mkdir_p dest_dir
        FileUtils.mv "#{lib_file}.js", dest_dir, :force => true
        puts "#{lib_file}.js has been installed at #{File.join(PUBLIC_DIR, Google::AjaxApi.versioned_path(lib, version, lib_file))}."
      end
    end
  end

end
