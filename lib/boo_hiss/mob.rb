module BooHiss
  class Mob
    def initialize(klass, method_name, tester, reporter)
      @klass, @method_name, @tester, @reporter = klass, method_name, tester, reporter
    end

    def enrage
      @reporter.record_initial_test_run
      result, err, out = tests_pass?
      @reporter.record_initial_test_result(result, err, out)

      @original_src = render_code
      @reporter.record_original_code(@original_src)

      mutation_count.times do |position|
        @reporter.mutation_test_run(position)
        sexp = Mutator.run(original_sexp, position)
        eval_sexp(position, sexp)

        @reporter.mutation_test_run(position)
        result, err, out = tests_pass?(position)
        @reporter.mutation_test_result(position, result, err, out)
      end
    end

    def eval_sexp(position, sexp)
      @reporter.code_sexp(position, sexp.deep_clone)
      code = nil
      begin
        code = Ruby2Ruby.new.process(sexp)
      rescue
        @reporter.exception_in_eval(position, $!)
        raise
      end
      @klass.class_eval code, "(mutation #{position} of #{@klass}\##{@method_name})"

      @reporter.code_diff(position, diff(@original_src, render_code))
    end

    def render_code
      Ruby2Ruby.translate(@klass, @method_name)
    end

    def tests_pass?(position = nil)
      @tester.passes?
    rescue
      @reporter.exception_in_test(position, $!)
      raise
    end

    def original_sexp
      @original_sexp ||= Sexp.from_array(ParseTree.translate(@klass, @method_name))
      @original_sexp.deep_clone
    end

    def mutation_count
      @mutation_count ||= begin
        count = Reaper.count_in(original_sexp)
        @reporter.count_mutations(count)
        count
      end
    end

    def diff(original, mutation)
      length = [original.split(/\n/).size, mutation.split(/\n/).size].max

      Tempfile.open("orig") do |a|
        a.puts(original)
        a.flush

        Tempfile.open("fail") do |b|
          b.puts(mutation)
          b.flush

          output = `diff -U #{length} --label original #{a.path} --label mutation #{b.path}`
          return output.sub(/^@@.*?\n/, '')
        end
      end
    end
  end
end
