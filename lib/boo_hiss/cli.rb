require "spec"
require "term/ansicolor"

module BooHiss
  class CLI
    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv
    end

    def run
      option_parser.parse!(@argv)
      klass = klass_for(@argv.shift)
      method_name = @argv.shift

      mob = Mob.new(klass, method_name, tester, reporter)
      mob.enrage
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] klass [method] ..."

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on("-v", "--version", "Display the version information") do
          puts BooHiss::VERSION
          exit
        end

        opts.on("-r library", "--require library", "Require the library to bootstrap your code") do |library|
          require library
        end

        opts.on("-o rspec-argv", "--options rspec-argv", "Arguments to pass through to RSpec") do |argv|
          @rspec_argv = argv
        end

        opts.on("-x", "--exit", "Exit on a mutation which doesn't cause a failure") do
          puts "I am going to exit on the first mutation which doesn't cause a failure"
          puts
          @exit_on_bad_mutation = true
        end

        opts.separator ""
      end
    end

    def exit_on_bad_mutation?
      @exit_on_bad_mutation
    end

    def tester
      @tester ||= Tester.new(@rspec_argv)
    end

    def reporter
      @reporter ||= Magic.new(self)
    end

    def klass_for(klass_name)
      list = klass_name.split("::")
      list.shift if list.first == ""
      obj = Object
      list.each do |x|
        # This is required because const_get tries to look for constants in the
        # ancestor chain, but we only want constants that are HERE
        obj = obj.const_defined?(x) ? obj.const_get(x) : obj.const_missing(x)
      end
      obj
    end

    class Magic
      C = Term::ANSIColor

      def initialize(cli)
        @cli = cli
      end

      def record_initial_test_result(result, err, out)
        if result
          puts "The test suite passed on a clean non-mutated code base"
          puts "Continuing with the mutations!"
          puts
        else
          C.red
          puts "The test suite did not pass with no mutations applied"
          puts "Fix the following problems: "
          C.reset
          puts err
          puts out
          exit
        end
      end

      def record_original_code(code)
        puts "The code being mutated is: "
        puts code
        puts
      end

      def count_mutations(count)
        puts "Found #{count} mutations to apply!"
        puts
      end

      def mutation_test_result(position, result, err, out)
        if result
          puts "Mutation #{position} caused no errors! Bad!"

          if @cli.exit_on_bad_mutation?
            puts "Time to get back to work"
            exit
          end
        else
          puts "Mutation #{position} triggered a test suite failure, good work!"
        end
        puts
      end

      def code_diff(position, diff)
        puts "The diff for mutation #{position} is: "
        diff.gsub!(/^(-.*)$/) {|f| C.red(f)}
        diff.gsub!(/^(\+.*)$/) {|f| C.green(f)}
        puts diff
        puts
      end

      def method_missing(name, *args)
        #puts "Got a call to #{name} with: "
        #p args
      end
    end

    class Tester
      def initialize(argv)
        @argv = argv
      end

      def passes?
        err, out = "", ""
        options = Spec::Runner::OptionParser.parse(@argv, StringIO.new(err), StringIO.new(out))
        result = Spec::Runner::CommandLine.run(options)
        if options.example_groups.empty?
          puts "No tests!?"
          puts out
          puts err
          exit
        end
        [result, err, out]
      end
    end

  end
end
