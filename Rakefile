# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'
require 'open3'
require 'etc'

# Discovers and runs each day's main.rb in its own process.
# Each solution defines top-level methods, so they can't share one process.
module Runner
  SLOW_MARKER = '# aoc: slow'
  Result = Struct.new(:path, :success, :output, :seconds)

  module_function

  def solutions(root, year: nil, include_slow: false)
    pattern = File.join(root, year || '[0-9][0-9][0-9][0-9]', 'day-[0-9][0-9]', 'main.rb')
    files = Dir.glob(pattern).sort
    include_slow ? files : files.reject { |f| slow?(f) }
  end

  def slow?(path)
    File.foreach(path).first(5).any? { |line| line.strip == SLOW_MARKER }
  end

  def run(files, out: $stdout, workers: Etc.nprocessors)
    queue = Queue.new
    files.each { |f| queue << f }
    queue.close
    results = []
    mutex = Mutex.new

    Array.new([workers, files.size].min) do
      Thread.new do
        while (file = queue.pop)
          result = run_one(file)
          mutex.synchronize do
            results << result
            out.puts format('%-4<status>s %7.2<secs>fs %<path>s',
                            status: result.success ? 'PASS' : 'FAIL', secs: result.seconds, path: file)
          end
        end
      end
    end.each(&:join)

    results.sort_by(&:path)
  end

  def run_one(file)
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    output, status = Open3.capture2e(RbConfig.ruby, File.basename(file), chdir: File.dirname(file))
    Result.new(file, status.success?, output, Process.clock_gettime(Process::CLOCK_MONOTONIC) - started)
  end
end

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
