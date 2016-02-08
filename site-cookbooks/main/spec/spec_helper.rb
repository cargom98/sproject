require 'chefspec'
require 'chefspec/berkshelf'
# ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '14.04'
  config.cookbook_path = '../../site-cookboks'
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.color = true
end
