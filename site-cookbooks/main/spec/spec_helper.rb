require 'chefspec'  
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
  config.cookbook_path = 'vendor'
  config.expect_with(:rspec) { |c| c.syntax = :should }
end
