require 'spec_helper'
describe Noteshred::Note do
  before(:each) do
    Noteshred.api_key = '4ba147490ab85e1c1d0ccb16d746722fe24190f6' #L
    @password     = 'password1865#'
    @content      = 'This is secret information'
    @title        = 'This is a title'
    @encrypted    = Noteshred::Crypto::V4.encrypt(@content, @password)
    @note         = Noteshred::Note.new
    @note.title   = @title
    @note.content = @content
    @note.password = @password
    #@note.recipients = ['cheyne@frontleft.com', 'cheyne@scriptrock.com']
  end

  context 'create' do
    before(:each) do
    end

    it 'should create a new note' do
      expect(@note.create['token']).to_not be_nil
    end
  end

  context 'push' do
    before(:each) do
    end

    it 'should push a pre-encrypted note' do
      @note.encrypt
      expect(@note.content).to be_nil
      expect(@note.encrypted_content).to_not be_nil
      expect(@note.push['token']).to_not be_nil
    end
  end
end