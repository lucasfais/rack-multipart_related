module Rack
  class MultipartRelated
    path = ::File.expand_path('../../..', __FILE__)
    
    version = nil
    version = $1 if path =~ /\/rack-multipart_related-([\w\.\-]+)/
    
    if version.nil?
      path = ::File.expand_path('../../../../.git', __FILE__)
      if ::File.exists?(path)
        require "step-up"
        version = StepUp::Driver::Git.last_version
      end
    end
    
    if version.nil?
      VERSION = "0.0.0"
    else
      version.sub!(/^v/, '')
      version.sub!(/\+\d*$/, '')
      VERSION = version
    end
  end
end
