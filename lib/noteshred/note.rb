module Noteshred
  class Note
    attr_accessor :content,
                  :title,
                  :password,
                  :password_hash,
                  :encrypted_content,
                  :encrypted_content_salt,
                  :encrypted_content_iv,
                  :shred_method,
                  :shred_by,
                  :hint

    # Shred Methods
    AFTER_READING = 1
    LATER_DATE    = 2

    def create
      if self.shred_method.nil?
        self.shred_method = AFTER_READING
      end

      # For creating notes that are encrypted on the server
      Noteshred::Api.post('/notes', self.hashify)
    end

    def push
      # For creating notes that are encrypted by the gem first then pushed to the server
      Noteshred::Api.post('/notes/push', self.hashify)
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

    def hashify
      self.instance_variables.each_with_object({}) { |var, hsh|
        hsh[var.to_s.delete("@")] = self.instance_variable_get(var)
      }
    end

    private

    def validate_content
      raise ArgumentError.new('Missing Password') if password.nil?
      raise ArgumentError.new('Password Must Be Minimum 8 Characters') if password.size < 8
      raise ArgumentError.new('Missing Content') if content.nil?
    end

    def validate_options
      raise ArgumentError.new('Missing Password') if password.nil?
      raise ArgumentError.new('Password Must Be Minimum 8 Characters') if password.size < 8
      raise ArgumentError.new('Missing Content') if content.nil?
    end
  end
end