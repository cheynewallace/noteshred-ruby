require 'spec_helper'
describe Noteshred::Crypto do
  context 'V4' do
    before(:each) do
      @password  = 'password1865#'
      @content   = 'This is secret information'
      @encrypted = Noteshred::Crypto::V4.encrypt(@content, @password)
    end

    it 'should have a salt and iv' do
      expect(@encrypted[:iv]).not_to be_empty
      expect(@encrypted[:salt]).not_to be_empty
      expect(@encrypted[:content]).not_to be_empty
      expect(@encrypted[:content]).not_to eq(@content)
    end

    it 'should decrypt successfully' do
      decrypted = Noteshred::Crypto::V4.decrypt(@encrypted[:content], @password, @encrypted[:salt], @encrypted[:iv])
      expect(decrypted).to eq(@content)
    end
  end
end