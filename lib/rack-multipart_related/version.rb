module RackMultipartRelated
  path = File.expand_path('../..', __FILE__)
  v = nil
  v = $1 if path =~ /\/rack-multipart_related-([\w\.\-]+)/
  if v.nil?
    $:.each do |path|
      if path =~ /\/rack-multipart_related-([\w\.\-]+)/
        v = $1
        break
      end
    end
  end
  if v.nil?
    path = File.expand_path('../../../.git', __FILE__)
    if File.exists?(path)
      require "step-up"
      v = StepUp::Driver::Git.last_version
    end
  end
  if v.nil?
    VERSION = "0.0.0"
  else
    v.sub!(/^v/, '')
    v.sub!(/\+$/, '')
    VERSION = v
  end
end