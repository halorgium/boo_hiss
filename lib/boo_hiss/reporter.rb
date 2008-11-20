module BooHiss
  class Reporter
    def record_initial_test_run
      raise NotImplementedError, "Define `record_initial_test_run' in a subclass"
    end

    def record_initial_test_result(result, err, out)
      raise NotImplementedError, "Define `record_initial_test_result(result, err, out)' in a subclass"
    end

    def record_original_code(code)
      raise NotImplementedError, "Define `record_original_code(code)' in a subclass"
    end

    def count_mutations(count)
      raise NotImplementedError, "Define `count_mutations(count)' in a subclass"
    end

    def mutation_test_run(position)
      raise NotImplementedError, "Define `mutation_test_run(position)' in a subclass"
    end

    def mutation_test_result(position, result, err, out)
      raise NotImplementedError, "Define `mutation_test_result(position, result, err, out)' in a subclass"
    end

    def code_sexp(position, sexp)
      raise NotImplementedError, "Define `code_sexp(position, sexp)' in a subclass"
    end

    def code_diff(position, diff)
      raise NotImplementedError, "Define `code_diff(position, diff)' in a subclass"
    end

    def exception_in_eval(position, exception)
      raise NotImplementedError, "Define `exception_in_eval(position, exception)' in a subclass"
    end

    def exception_in_test(position, exception)
      raise NotImplementedError, "Define `exception_in_test(position, exception)' in a subclass"
    end
  end
end
