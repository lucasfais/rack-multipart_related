require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class MultipartRelatedTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use Rack::MultipartRelated
      run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['success']] }
    end
  end
  
  def imagefile
    @image_file ||= File.open(File.expand_path(File.dirname(__FILE__) + '/../resources/image.png'))
  end
  
  def make_tempfile(name, text)
    tempfile = Tempfile.new(name)
    tempfile.puts(text)
    tempfile.rewind
    tempfile
  end

  def test_request_without_multipart_related
    get "/"
  
    assert_equal "http://example.org/", last_request.url
    assert last_response.ok?
  end
  
  def test_mutlipart_related_with_correct_json
    
    jsonfile = make_tempfile("json", '{"user": {"name": "Jhon", "avatar": "cid:avatar_image"} }')

    request_form_hash = {
      "json" => {
        :type => "application/json; charset=UTF-8", 
        :tempfile => jsonfile, 
        :head => "Content-Type: application/json; charset=UTF-8\r\nContent-Disposition: inline; name=\"json\"\r\n", 
        :name => "json"
      }, 
      "avatar_image" => {
        :type => "image/png", 
        :filename =>"image.png", 
        :tempfile => imagefile, 
        :head => "Content-Type: image/gif\r\nContent-Disposition: inline; name=\"avatar_image\"; filename=\"image.png\"\r\n", 
        :name =>"avatar_image"
      }
    }
    
    expected_request_form_hash_after_middleware = {
      "user" => {
        "name" => "Jhon", 
        "avatar" => {
          :type => "image/png", 
          :filename =>"image.png", 
          :tempfile => imagefile, 
          :head => "Content-Type: image/gif\r\nContent-Disposition: inline; name=\"avatar_image\"; filename=\"image.png\"\r\n", 
          :name =>"avatar_image"
        }
      }
    }
    
    env = {
      'REQUEST_METHOD' => 'POST',
      'CONTENT_TYPE' => 'multipart/related; boundary="the_boundary"; type="application/json"; start="json"',
      'PATH_INFO' => '/some/path',
      'rack.request.form_hash' => request_form_hash
    }
    
    request(env['PATH_INFO'], env)
    
    assert last_response.ok?
    assert_equal last_request.env["rack.request.form_hash"], expected_request_form_hash_after_middleware
  end
end
