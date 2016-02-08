require 'rake'
require 'rspec/core/rake_task'
require 'rake-foodcritic'
require 'rubocop/rake_task'

# Rubocop before rspec so we don't lint vendored cookbooks
desc 'Run all tests except Kitchen (default task)'
task integration: %w(rubocop foodcritic unit)
task default: :integration

# Lint the cookbook
desc 'Run linters'
task lint: [:rubocop, :foodcritic]

# Lint the cookbook
desc 'Run all linters: rubocop and foodcritic'
task run_all_linters: [:rubocop, :foodcritic]

# Run the whole shebang
desc 'Run all tests'
task test: [:lint, :integration, :unit]

# Foodcritic
desc 'Run foodcritic lint checks'
task :foodcritic do
  if Gem::Version.new('1.9.2') <= Gem::Version.new(RUBY_VERSION.dup)
    puts 'Running Foodcritic tests...'
    FoodCritic::Rake::LintTask.new do |t|
      t.options = { fail_tags: ['any'] }
      puts 'done.'
    end
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

# Rubocop
desc 'Run Rubocop lint checks'
task :rubocop do
  RuboCop::RakeTask.new
end

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = 'site-cookbooks/*/spec/unit/*/*_spec.rb'
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end
