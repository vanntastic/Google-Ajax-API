require 'test_helper'

class Google::AjaxApiTest < Test::Unit::TestCase
  include Google::AjaxApi

  unless Object.const_defined? "Rails"
    class ::Rails; def self.env=(val); @env=val; end; def self.env; @env; end; end
  end

  def test_jquery_cached_minified_rails_dev
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.js'
    expected_env = :development
    expected = "/javascripts/#{fw}/#{version}/#{fw_filename}#{ext}"
    got = nil
    Rails.env=(expected_env) if Rails.respond_to?(:env=)
    if Rails.env == expected_env
      got = cached_url_or_filename('jquery', '1.3.2', {:minified => true})
    else
      got = cached_url_or_filename('jquery', '1.3.2', {:env => expected_env, :minified => true})
    end
    assert got == expected
  end

  def test_jquery_cached_minified_rails_prod
    expected_env = :production
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.min.js'
    expected = "#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"
    got = nil
    Rails.env=(expected_env) if Rails.respond_to?(:env=)
    if Rails.env == expected_env
      got = cached_url_or_filename('jquery', '1.3.2', {:minified => true})
    else
      got = cached_url_or_filename('jquery', '1.3.2', {:env => expected_env, :minified => true})
    end
    assert got == expected
  end

  def test_scriptaculous_urls
    fw = 'scriptaculous'
    version = '1.8.2'
    fw_filename = 'effects'
    ext = ".js"

    expected = "#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"
    got = cached_url_or_filename(fw, version, {:filename => fw_filename, :env => :production})

    assert got == expected

    fw_filename = 'dragdrop'
    expected = "#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"
    got = cached_url_or_filename(fw, version, {:filename => fw_filename, :env => :production})
    assert got == expected

    fw_filename = 'controls'
    expected = "#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"
    got = cached_url_or_filename(fw, version, {:filename => fw_filename, :env => :production})
    assert got == expected
  end

  def test_jquery_cached
    expected = ["/javascripts/jquery/1.3.2/jquery.js"]

    got = js_urls_or_filenames('jquery-1.3.2', :cached, :development_env)
    assert got == expected

    got = js_urls_or_filenames('jquery-1.3.2', :cached, :test_env)
    assert got == expected
  end

  def test_jquery_and_ui_cached
    expected = ["/javascripts/jquery/1.3.2/jquery.js", "/javascripts/jqueryui/1.7.1/jquery-ui.js"]

    got = js_urls_or_filenames('jquery-1.3.2','jqueryui-1.7.1', :cached, :development_env)
    assert got == expected

    got = js_urls_or_filenames('jquery-1.3.2','jqueryui-1.7.1', :cached, :test_env)
    assert got == expected
  end

  def test_jquery_notcached
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.js'
    expected = ["#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"]
    got = js_urls_or_filenames('jquery-1.3.2', :production_env)
    assert got == expected

    got = js_url_or_filename('jquery', '1.3.2')
    assert got == expected.first
  end

  def test_jquery_and_ui_notcached
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.js'
    expected = ["#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"]
    fw, version, fw_filename, ext = 'jqueryui', '1.7.1', 'jquery-ui', '.js'
    expected << "#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"

    got = js_urls_or_filenames('jquery-1.3.2', 'jqueryui-1.7.1', :production_env)
    assert got == expected
  end

  def test_jquery_cache_ignored
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.js'
    expected = ["#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"]
    got = js_urls_or_filenames('jquery-1.3.2', :cached, :production_env)
    assert got == expected
  end

  def test_jquery_and_ui_cache_ignored
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.js'
    expected = ["#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"]
    fw, version, fw_filename, ext = 'jqueryui', '1.7.1', 'jquery-ui', '.js'
    expected << "#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"

    got = js_urls_or_filenames('jquery-1.3.2', 'jqueryui-1.7.1', :cached, :production_env)
    assert got == expected
  end

  def test_jquery_minified_cached
    # TODO: support minified downloads
    expected = ["/javascripts/jquery/1.3.2/jquery.js"]

    got = js_urls_or_filenames('jquery-1.3.2', :cached, :minified, :development_env)
    assert got == expected

    got = js_urls_or_filenames('jquery-1.3.2', :cached, :minified, :test_env)
    assert got == expected
  end

  def test_jquery_minified_cache_ignored
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.min.js'
    expected = ["#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"]

    got = js_urls_or_filenames('jquery-1.3.2', :cached, :minified, :production_env)
    assert got == expected

    got = cached_url_or_filename('jquery', '1.3.2', {:filename => 'jquery', :skip_cache => true, :minified => true})
    assert got == expected.first
  end

  def test_jquery_and_ui_minified_cache_ignored
    fw, version, fw_filename, ext = 'jquery', '1.3.2', 'jquery', '.min.js'
    expected = ["#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"]
    fw, version, fw_filename, ext = 'jqueryui', '1.7.1', 'jquery-ui', '.min.js'
    expected << "#{BASE_URL}#{fw}/#{version}/#{fw_filename}#{ext}"

    got = js_urls_or_filenames('jquery-1.3.2', 'jqueryui-1.7.1', :cached, :minified, :production_env)
    assert got == expected
  end
end
