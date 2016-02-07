require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = 'site-cookbooks/*/spec/unit/*/*_spec.rb'
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end

task :default => [:unit]