module BooHiss
  class Processor < SexpProcessor
    def initialize(mutator)
      super()
      @mutator = mutator
      self.warn_on_default = true
      self.default_method = :unhandled
      self.strict = true
      self.auto_shift_type = true
    end

    def process_call(exp)
      recv = process(exp.shift)
      meth = exp.shift
      args = process(exp.shift)

      out = [:call, recv, meth]
      out << args if args

      stack = caller.map { |s| s[/process_\w+/] }.compact

      if stack.first != "process_iter" then
        @mutator.handle out
      else
        Sexp.from_array(out)
      end
    end

    def process_defn(exp)
      result = [:defn, exp.shift]
      result << process(exp.shift) until exp.empty?
      @mutator.handle result
    end

    # So process_call works correctly
    def process_iter(exp)
      Sexp.from_array([:iter, process(exp.shift), process(exp.shift), process(exp.shift)])
    end

    def process_asgn(type, exp)
      var = exp.shift
      if exp.empty? then
        @mutator.handle [type, var]
      else
        @mutator.handle [type, var, process(exp.shift)]
      end
    end

    def process_cvasgn(exp)
      process_asgn :cvasgn, exp
    end

    def process_dasgn(exp)
      process_asgn :dasgn, exp
    end

    def process_dasgn_curr(exp)
      process_asgn :dasgn_curr, exp
    end

    def process_iasgn(exp)
      process_asgn :iasgn, exp
    end

    def process_gasgn(exp)
      process_asgn :gasgn, exp
    end

    def process_lasgn(exp)
      process_asgn :lasgn, exp
    end

    def process_lit(exp)
      @mutator.handle [:lit, exp.shift]
    end

    def process_str(exp)
      @mutator.handle [:str, exp.shift]
    end

    def process_if(exp)
      @mutator.handle [:if, process(exp.shift), process(exp.shift), process(exp.shift)]
    end

    def process_true(exp)
      @mutator.handle [:true]
    end

    def process_false(exp)
      @mutator.handle [:false]
    end

    def process_while(exp)
      cond, body, head_controlled = grab_conditional_loop_parts(exp)
      @mutator.handle [:while, cond, body, head_controlled]
    end

    def process_until(exp)
      cond, body, head_controlled = grab_conditional_loop_parts(exp)
      @mutator.handle [:until, cond, body, head_controlled]
    end

    def unhandled(exp)
      result = Sexp.new(exp.shift)
      until exp.empty?
        node = exp.shift
        case node
        when Array
          result << process(node)
        else
          result << s(node)
        end
      end
      result
    end

    def grab_conditional_loop_parts(exp)
      cond = process(exp.shift)
      body = process(exp.shift)
      head_controlled = exp.shift
      return cond, body, head_controlled
    end
  end
end
