require 'openssl'
require 'digest'
require 'securerandom'

module Noteshred
  module Crypto
    module V4
      ITERATIONS = 20000

      # Outputs UTF-8 encoded object for storing in database
      def self.encrypt(content,pass)
        raise ArgumentError, 'Content and password required' if content.empty? || pass.empty?
        cipher     = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        iv         = cipher.random_iv
        salt       = SecureRandom.hex(16)
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass, salt, ITERATIONS, cipher.key_len)
        result     = cipher.update(content)
        result << cipher.final
        return {
          :content => Noteshred::Tools.encode_utf8(result),
          :iv      => Noteshred::Tools.encode_utf8(iv),
          :salt    => salt,
          :version => 4
        }
      end

      # Expects UTF-8 encoded strings from the encrypt method
      def self.decrypt(content,pass,salt,iv)
        content    = Noteshred::Tools.decode_utf8(content)
        cipher     = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.iv  = Noteshred::Tools.decode_utf8(iv)
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass, salt, ITERATIONS, cipher.key_len)
        result     = cipher.update(content)
        result << cipher.final
      end

      def self.hash(pass,salt)
        return OpenSSL::PKCS5::pbkdf2_hmac_sha1(pass, salt, ITERATIONS, 32)
      end
    end
  end
end
