module BooHiss
  class Reaper
    def self.count_in(exp)
      new(exp).mutation_count
    end
    
    def initialize(exp)
      @exp, @incr = exp, 0
    end

    def mutation_count
      Processor.run(self, @exp)
      @incr
    end

    def handle(node)
      @incr += 1
      Sexp.from_array(node)
    end
  end
end
