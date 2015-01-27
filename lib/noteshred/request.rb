module Noteshred
  class Request
    attr_accessor :message,
                  :recipient_email,
                  :password,
                  :confirm_password

    def create
      validate_attributes
      self.confirm_password = self.password
      Noteshred::API.post('/note_requests', Noteshred::Tools.hashify(self))
    end

    private

    def validate_attributes
      raise ArgumentError.new('Missing Password') if password.nil?
      raise ArgumentError.new('Password Must Be Minimum 8 Characters') if password.size < 8
      raise ArgumentError.new('Missing Message') if message.nil?
      raise ArgumentError.new('Missing Recipient Email') if recipient_email.nil?
    end

  end
end
