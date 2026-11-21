# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require_relative '../lib/runner'

class RunnerTest < Minitest::Test
  def setup
    @root = Dir.mktmpdir
    write('2015/day-01/main.rb', "# solved\n")
    write('2015/day-02/main.rb', "# aoc: slow\n")
    write('2016/day-01/main.rb', "# solved\n")
    write('2016/day-01/README.md', "# not a solution\n")
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def test_finds_all_fast_solutions_sorted
    assert_equal %w[2015/day-01/main.rb 2016/day-01/main.rb], relative(Runner.solutions(@root))
  end

  def test_includes_slow_solutions_when_asked
    assert_equal %w[2015/day-01/main.rb 2015/day-02/main.rb 2016/day-01/main.rb],
                 relative(Runner.solutions(@root, include_slow: true))
  end

  def test_filters_by_year
    assert_equal %w[2016/day-01/main.rb], relative(Runner.solutions(@root, year: '2016'))
  end

  def test_empty_when_year_has_no_solutions
    assert_empty Runner.solutions(@root, year: '1999')
  end

  def test_run_reports_failures
    write('2017/day-01/main.rb', "exit 0\n")
    write('2017/day-02/main.rb', "warn 'boom'; exit 1\n")
    results = Runner.run(Runner.solutions(@root, year: '2017'), out: StringIO.new)

    assert_equal [true, false], results.map(&:success)
    assert_includes results.last.output, 'boom'
  end

  private

  def write(path, content)
    full = File.join(@root, path)
    FileUtils.mkdir_p(File.dirname(full))
    File.write(full, content)
  end

  def relative(paths)
    paths.map { |p| p.delete_prefix("#{@root}/") }
  end
end
