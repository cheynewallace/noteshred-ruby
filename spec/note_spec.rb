require 'spec_helper'
describe Noteshred::Note do
  context 'CREATE' do
    #Noteshred.api_key = '72641f2be0ad9e5b22c4a5e5b97fbcc8939389ab' #Remote
    before(:each) do
      Noteshred.api_key = '<key>'
      @password     = 'password1865#'
      @content      = 'This is secret information'
      @title        = 'This is a title'
      @encrypted    = Noteshred::Crypto::V4.encrypt(@content, @password)
      @note         = Noteshred::Note.new
      @note.title   = @title
      @note.content = @content
      @note.password = @password
    end

    it 'should create a new note' do
      @note.create
    end

  end
end