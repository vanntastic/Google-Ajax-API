module Google
  module AjaxApi
    extend self

    VALID_FLAGS = [:cached, :minified, :production_env, :development_env, :test_env]
    BASE_URL = "http://ajax.googleapis.com/ajax/libs/"
    EXCEPTIONS = %w(ext chrome)

    # View http://code.google.com/apis/ajaxlibs/documentation/ for list of frameworks
    # USAGE:
    #
    #   include_js 'framework-version', *option_flags
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
      js_urls_or_filenames(*frameworks).map { |key| javascript_include_tag(key) }
    end

    def js_url_or_filename(framework, version, filename=framework, _skip_cache=true, options={})
      _skip_cache ? "#{BASE_URL}#{framework}/#{version}/#{filename}#{extension(options)}" : filename
    end

    def js_urls_or_filenames(*frameworks)
      extract_flags! options={}, frameworks

      _skip_cache = skip_gajax_cache?(options)
      frameworks.map do |framework|
        fw, version = framework.split("-").first, framework.split("-").last

        # make an exception for ext-core and chrome-frame
        fw = "#{framework.split('-').first}-#{framework.split('-')[1]}" if EXCEPTIONS.include?(framework.split("-").first)
        fw_filename = fw == "jqueryui" ? "jquery-ui" : fw

        js_url_or_filename(fw, version, fw_filename, _skip_cache, options)
      end
    end

    def skip_gajax_cache?(options={})
      production?(options) || !options[:cached]
    end

    private

    def production?(options={})
      (options[:env] || env).to_s == "production"
    end

    def env
     Rails.respond_to?(:env) ? Rails.env : RAILS_ENV
    end

    def extract_flags! flags, frameworks
      while VALID_FLAGS.include?(frameworks.last)
        flag, value = flag_value(frameworks.pop)
        flags[flag] = value
      end
    end

    def flag_value(input_flag)
      flag, value = case input_flag
                    when :production_env
                      [:env, :production]
                    when :development_env
                      [:env, :development]
                    when :test_env
                      [:env, :test]
                    else
                      [input_flag, true]
                    end
    end

    def extension(options={})
      "".tap do |result|
        result <<( !!options[:minified] ? ".min" : "" )
        result << ".js"
      end
    end

  end
end
