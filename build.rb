require File.expand_path('lib/noteshred/version', File.dirname(__FILE__))
`gem build noteshred.gemspec && gem install noteshred-#{Noteshred::VERSION}.gem`
puts "Built Gem Version #{Noteshred::VERSION}"

