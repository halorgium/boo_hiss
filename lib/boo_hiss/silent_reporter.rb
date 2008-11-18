module BooHiss
  class SilentReporter < Reporter
    class Mutation
      def initialize(position)
        @position = position
      end
      attr_accessor :result, :err, :out, :sexp, :diff, :exception_in_eval, :exception_in_test
    end

    def initialize
      @mutations = {}
    end
    attr_reader :initial_test_result, :mutation_count, :mutations

    def record_initial_test_run
    end

    def record_initial_test_result(result, err, out)
      @initial_test_result, @initial_err, @initial_out = result, err, out
    end

    def count_mutations(count)
      @mutation_count = count
    end

    def mutation_test_run(position)
      @mutations[position] = Mutation.new(position)
    end

    def mutation_test_result(position, result, err, out)
      @mutations[position].result = result
      @mutations[position].err = err
      @mutations[position].out = out
    end

    def code_sexp(position, sexp)
      @mutations[position].sexp = sexp
    end

    def code_diff(position, diff)
      @mutations[position].diff = diff
    end

    def exception_in_eval(position, exception)
      @mutations[position].exception_in_eval = exception
    end

    def exception_in_test(position, exception)
      @mutations[position].exception_in_test = exception
    end
  end
end
