module BooHiss
  class SilentReporter < Reporter
    class Mutation
      def initialize(position)
        @position = position
      end
      attr_accessor :position, :result, :err, :out, :sexp, :diff, :exception_in_eval, :exception_in_test

      def passed?
        result
      end
    end

    def initialize(cli)
      @mutations = []
    end
    attr_reader :initial_test_result, :mutation_count, :mutations, :completed

    def record_initial_test_run
    end

    def record_initial_test_result(result, err, out)
      @initial_test_result, @initial_err, @initial_out = result, err, out
    end

    def exception_in_initial_test(exception)
      @initial_test_exception = exception
    end

    def record_original_code(code)
    end

    def count_mutations(count)
      @mutation_count = count
    end

    def mutation_test_run(position)
      @mutations << Mutation.new(position)
    end

    def mutation_test_result(position, result, err, out)
      mutation = mutation_at(position)
      mutation.result = result
      mutation.err = err
      mutation.out = out
    end

    def code_sexp(position, sexp)
      mutation_at(position).sexp = sexp
    end

    def code_diff(position, diff)
      mutation_at(position).diff = diff
    end

    def completed
      @completed = true
    end

    def exception_in_eval(position, exception)
      mutation_at(position).exception_in_eval = exception
    end

    def exception_in_test(position, exception)
      mutation_at(position).exception_in_test = exception
    end

    def mutations_with_eval_exceptions
      mutations.select do |m|
        m.exception_in_eval
      end
    end

    def mutations_with_test_exceptions
      mutations.select do |m|
        m.exception_in_test
      end
    end

    def unsuccessful_mutations
      mutations.select do |m|
        m.passed?
      end
    end

    def mutation_at(position)
      if mutation = @mutations.find {|m| m.position == position}
        mutation
      else
        raise IndexError, "Could not find a mutation at position #{position}"
      end
    end
  end
end
