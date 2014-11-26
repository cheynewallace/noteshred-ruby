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
                  :hint

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

    def encrypt
      validate_content
      crypt = Noteshred::Crypto::V4.encrypt(self.content, self.password)
      self.encrypted_content      = crypt[:content]
      self.encrypted_content_iv   = crypt[:iv]
      self.encrypted_content_salt = crypt[:salt]
      self.content                = nil
      self.password               = nil
      self
    end

    private

    def validate_content
      raise ArgumentError.new('Missing Password') if password.nil?
      raise ArgumentError.new('Password Must Be Minimum 8 Characters') if password.size < 8
      raise ArgumentError.new('Missing Content') if content.nil?
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