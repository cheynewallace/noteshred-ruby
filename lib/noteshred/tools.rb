require 'base64'
module Noteshred
  module Tools
    def self.encode_utf8(string)
      Base64.encode64(string).encode('utf-8')
    end

    def self.decode_utf8(string)
      Base64.decode64(string.encode('ascii-8bit')).force_encoding('utf-8')
    end

    def self.hashify(obj)
      obj.instance_variables.each_with_object({}) { |var, hsh|
        hsh[var.to_s.delete("@")] = obj.instance_variable_get(var)
      }
    end
  end
end