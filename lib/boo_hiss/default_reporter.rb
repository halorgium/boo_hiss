require "term/ansicolor"

module BooHiss
  class DefaultReporter
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

    def code_sexp(position, sexp)
      return unless $debug
      puts "The sexp for mutation #{position} is: "
      p sexp
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
end
