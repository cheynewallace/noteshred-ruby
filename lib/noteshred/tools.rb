require 'base64'
module Noteshred
  module Tools
    def self.encode_utf8(string)
      Base64.encode64(string).encode('utf-8')
    end

    def self.decode_utf8(string)
      Base64.decode64 string.encode('ascii-8bit')
    end
  end
end