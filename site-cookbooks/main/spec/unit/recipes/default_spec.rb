require 'chefspec'
require_relative '../../spec_helper'


describe 'main::default' do
  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should include the nginx recipe' do
  	stub_command("which nginx").and_return(true)
  	stub_command("test -f /var/run/mysqld/mysqld.sock").and_return(true)
    chef_run.should include_recipe 'main::nginx'
  end
  it 'should include the hhvm recipe' do
  	  stub_command("which nginx").and_return(true)
  	  stub_command("test -f /var/run/mysqld/mysqld.sock").and_return(true)
      chef_run.should include_recipe 'main::hhvm'
    end
end