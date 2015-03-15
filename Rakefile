require 'foodcritic'
require 'rubocop/rake_task'

RuboCop::RakeTask.new
FoodCritic::Rake::LintTask.new do |t|
  t.options = { fail_tags: ['any'] }
end

desc 'Run tests'
task default: [:rubocop, :foodcritic]
