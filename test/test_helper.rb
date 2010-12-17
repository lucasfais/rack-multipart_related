require 'rubygems'
require 'test/unit'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack/multipart_related'

begin
  require "redgreen"
  require "ruby-debug"
rescue LoadError
  # Not required gems.
end

