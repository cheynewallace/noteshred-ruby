require 'spec_helper'
describe Noteshred::Request do
  before(:each) do
    set_key
    @request                  = Noteshred::Request.new
    @request.message          = 'Send me something private'
    @request.recipient_email  = 'user@someguy.com'
    @request.password         = 'password1234'
  end

  context 'create' do
    it 'should create a new request' do
      result = @request.create
      expect(result['note']['token']).to_not be_nil
    end

    it 'should error when missing email address' do
      @request.recipient_email= 'wrong'
      result = @request.create
      expect(result['status']).to eq('validation_error')
      expect(result['message']).to eq('Validation failed: Recipient email must be a valid email address')
    end
  end

end
