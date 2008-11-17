module BooHiss
  class Reaper
    def self.locate_in(exp)
      r = new
      r.locate_in(exp)
      r
    end

    def locate_in(exp)
      p = Processor.new(self)
      p.process(exp)
    end

    def handle(node)
      sexp = Sexp.from_array(node)
      mutations << node
      sexp
    end

    def mutations
      @mutations ||= []
    end
  end
end
