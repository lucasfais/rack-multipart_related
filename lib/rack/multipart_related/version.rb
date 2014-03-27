module Rack
  class MultipartRelated
    version = nil
    version = $1 if ::File.expand_path('../../..', __FILE__) =~ /\/rack-multipart_related-([\w\.\-]+)/
    version = nil unless /^([^-]+)-([0-9]+)-[^-]+$/.match(version)
    if version.nil? && ::File.exists?(::File.expand_path('../../../../.git', __FILE__))
      require "step-up"
      version = StepUp::Driver::Git.last_version
    end
    version = "0.0.0" if version.nil?
    VERSION = version.gsub(/^v?([^\+]+)\+?\d*$/, '\1')
  end
end
