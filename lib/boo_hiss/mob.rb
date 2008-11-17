module BooHiss
  class Mob
    def initialize(klass, method_name)
      @klass, @method_name = klass, method_name
    end

    def enrage
      mutator.run
    end

    def exp
      @exp ||= ParseTree.translate(@klass, @method_name)
      @exp.deep_clone
    end

    def mutator
      @mutator ||= Mutator.new(self, exp)
    end

    def mutations
      @mutations ||= Reaper.locate_in(exp)
    end
  end
end
