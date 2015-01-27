require 'bcrypt'
module Noteshred
  class Note
    attr_accessor :content,
                  :title,
                  :password,
                  :password_hash,
                  :recipients,
                  :encrypted_content,
                  :encrypted_content_salt,
                  :encrypted_content_iv,                  
                  :shred_method,
                  :shred_by,
                  :hint,
                  :version

    # Shred Methods
    SHRED_AFTER_READING = 1
    SHRED_LATER         = 2

    def create
      # For creating notes that are encrypted on the server
      validate_content
      validate_options
      Noteshred::API.post('/notes', Noteshred::Tools.hashify(self))
    end

    def push
      # For creating notes that are encrypted by the gem first then pushed to the server
      validate_options
      if self.encrypted_content_salt.nil? || encrypted_content_iv.nil?
        raise ArgumentError.new('No encrypted content found. Must call .encrypt before pushing')
      end

      Noteshred::API.post('/notes/push', Noteshred::Tools.hashify(self))
    end

    def pull(token,pass)
      # For pulling raw encrypted notes from the server
      # TODO: Implement server side portion
      if token.nil? || password.nil?
        raise ArgumentError.new('token and password params are required')
      end
      Noteshred::API.get('/notes/pull', {:password => pass, :token => token})
    end

    def encrypt
      validate_content
      crypt = Noteshred::Crypto::V4.encrypt(self.content, self.password)
      self.encrypted_content      = crypt[:content]
      self.encrypted_content_iv   = crypt[:iv]
      self.encrypted_content_salt = crypt[:salt]
      self.version                = crypt[:version]
      self.password_hash          = BCrypt::Password.create(self.password)
      self.content                = nil
      self.password               = nil
      return self
    end

    def decrypt
      validate_encrypted_content
      self.content                = Noteshred::Crypto::V4.decrypt(self.encrypted_content, self.password, self.encrypted_content_salt, self.encrypted_content_iv)
      self.encrypted_content_iv   = nil
      self.encrypted_content_salt = nil
      self.encrypted_content      = nil
      self.password_hash          = nil
      return self
    end

    def self.share(token,recipients,comments)
      # Receive comma seperated list of recipients
      if recipients.nil?
        raise ArgumentError.new('Recipients are required')
      end
      if token.nil?
        raise ArgumentError.new('Token is required')
      end
      Noteshred::API.post("/notes/#{token}/share", {:dest_email => recipients, :comments => comments})
    end

    private

    def validate_content
      raise ArgumentError.new('Missing Password') if password.nil?
      raise ArgumentError.new('Password Must Be Minimum 8 Characters') if password.size < 8
      raise ArgumentError.new('Missing Content') if content.nil?
    end

    def validate_encrypted_content
      raise ArgumentError.new('Missing Password') if password.nil?
      raise ArgumentError.new('Missing Content') if encrypted_content.nil?
      raise ArgumentError.new('Missing Salt') if encrypted_content_salt.nil?
    end

    def validate_options
      raise ArgumentError.new('shred_by date not set') if shred_method == SHRED_LATER && shred_by.nil?
      if !recipients.nil?
        raise ArgumentError.new('recipients must be an array.') unless recipients.kind_of?(Array)
      end

      if self.shred_method.nil?
        self.shred_method = SHRED_AFTER_READING
      end
    end
  end
end