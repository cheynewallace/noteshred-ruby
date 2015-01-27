require 'bundler/setup'
Bundler.setup

require 'noteshred'

RSpec.configure do |config|
  # some (optional) config here
end

def set_key
  Noteshred.api_key = '4ba147490ab85e1c1d0ccb16d746722fe24190f6' #Local
end