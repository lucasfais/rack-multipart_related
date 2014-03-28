require 'json'

module Rack
  class MultipartRelated
    autoload :VERSION, 'rack/multipart_related/version.rb'

    def initialize(app)
      @app = app
    end

    def call(env)
      content_type = env['CONTENT_TYPE']

      if content_type =~ /^multipart\/related/ni

        start_part = content_type[/.* start=(?:"((?:\\.|[^\"])*)"|([^;\s]*))/ni] && ($1 || $2)
        start_part_type = content_type[/.* type=(?:"((?:\\.|[^\"])*)"|([^;\s]*))/ni] && ($1 || $2)

        if start_part_type == "application/json"

          params = env["rack.request.form_hash"]
          start_part_attribute = get_attribute(params, start_part)
          if start_part_attribute.is_a? String then
            json_data = ::JSON.parse(start_part_attribute)
          else
            json_data = ::JSON.parse(start_part_attribute[:tempfile].read)
            start_part_attribute[:tempfile].rewind
            env['START_CONTENT_TYPE'] ||= start_part_attribute[:type]
          end

          new_params = handle_atributtes_with_part_refs(json_data, params)
          env["rack.request.form_hash"] = new_params
        end
      end

      @app.call(env)
    end

    private
    def get_attribute(hash, attributes)
      attributes = attributes.scan(/[^\[\]]+/) if attributes.is_a?(String)
      attribute = attributes.shift
      value = attribute.nil? ? nil : hash[attribute]
      
      if value.is_a?(Hash) && ! attributes.empty?
        get_attribute(value, attributes)
      else
        value
      end
    end

    def handle_atributtes_with_part_refs(data, original_params)

      if data.kind_of?(String)
        part_ref = data[/^cid:(.+)$/ni, 1]

        if part_ref
          data = get_attribute(original_params, part_ref)
        end
      elsif data.kind_of?(Array)
        data.each_with_index do |value, index|
          data[index] = handle_atributtes_with_part_refs(value, original_params)
        end
      elsif data.kind_of?(Hash)
        data.each do |key, value|
          data[key] = handle_atributtes_with_part_refs(value, original_params)
        end
      end

      data
    end
  end
end
