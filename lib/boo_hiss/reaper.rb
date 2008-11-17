module BooHiss
  class Reaper
    def self.locate_in(exp)
      new.locate_in(exp)
    end

    def locate_in(exp)
      p = Processor.new(self)
      p.process(exp)
      mutations
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
