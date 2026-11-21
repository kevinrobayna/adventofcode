# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'
require_relative 'lib/runner'

RuboCop::RakeTask.new(:lint)

Rake::TestTask.new('test:lib') do |t|
  t.test_files = FileList['test/**/*_test.rb']
end

def run_solutions(include_slow:)
  files = Runner.solutions(__dir__, year: ENV.fetch('YEAR', nil), include_slow: include_slow)
  abort 'No solutions found' if files.empty?

  failures = Runner.run(files).reject(&:success)
  failures.each { |f| puts "\n=== FAIL #{f.path}\n#{f.output}" }
  abort "#{failures.size} of #{files.size} solutions failed" if failures.any?
  puts "All #{files.size} solutions passed"
end

desc 'Run all solutions except those marked "# aoc: slow" (YEAR=2015 to filter)'
task test: 'test:lib' do
  run_solutions(include_slow: false)
end

desc 'Run all solutions including slow ones (YEAR=2015 to filter)'
task 'test:all' => 'test:lib' do
  run_solutions(include_slow: true)
end

task default: %i[lint test]
