require 'spec_helper'
describe Noteshred::Note do
  before(:each) do
    Noteshred.api_key = '4ba147490ab85e1c1d0ccb16d746722fe24190f6' #Local
    @password         = 'password1865#'
    @content          = 'This is secret information'
    @title            = 'This is a title'
    @encrypted        = Noteshred::Crypto::V4.encrypt(@content, @password)
    @note             = Noteshred::Note.new
    @note.title       = @title
    @note.content     = @content
    @note.password    = @password
    @note.recipients  = ['cheyne@somewhere.com']
  end

  context 'create' do
    it 'should create a new note' do
      expect(@note.create['token']).to_not be_nil
    end
  end

  context 'encrypt' do
    it 'should encrypt a note' do
      @note.encrypt
      expect(@note.content).to be_nil
      expect(@note.encrypted_content).to_not be_nil
    end
  end

  context 'decrypt' do
    it 'should decrypt a note' do
      @note.encrypt
      expect(@note.content).to be_nil
      expect(@note.encrypted_content).to_not be_nil

      @note.password = @password
      @note.decrypt
      expect(@note.content).to eq(@content)
      expect(@note.encrypted_content).to be_nil
    end
  end


  context 'push' do
    it 'should push a pre-encrypted note' do
      @note.encrypt
      expect(@note.content).to be_nil
      expect(@note.encrypted_content).to_not be_nil
      expect(@note.push['token']).to_not be_nil
    end
  end

  context 'share' do
    it 'should share a note' do
      result = Noteshred::Note.share('7561ab7fbd','someguy@somewhere.com','Here is the info')
      expect(JSON.parse(result)['status']).to eq('accepted')
    end
  end
end