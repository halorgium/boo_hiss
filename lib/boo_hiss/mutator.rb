module BooHiss
  class Mutator
    def self.run(mutation, exp)
      new(mutation, exp).run
    end

    def initialize(mutation, exp)
      @mutation, @exp = mutation, exp
    end

    def run
      @processor = Processor.new(self)
      @processor.process(@exp)
    end

    def handle(node)
      mutation_method = "mutate_#{node.first}"
      unless respond_to?(mutation_method)
        raise UnsupportedNodeError, "`#{node.first}' is not supported as a mutatable node"
      end

      #increment_node_count node

      if @mutation.mutate?(node)
        #increment_mutation_count node
        Sexp.from_array(send(mutation_method, node))
      else
        Sexp.from_array(node)
      end
    end

    # Remove the body of the defn
    def mutate_defn(node)
      [:defn, node[0], [:scope, [:block, [:args], [:nil]]]]
    end

    # Replaces the call node with nil.
    def mutate_call(node)
      [:nil]
    end

    def mutate_asgn(node)
      type = node.shift
      var = node.shift
      if node.empty? then
        [:lasgn, :_heckle_dummy]
      else
        if node.last.first == :nil then
          [type, var, [:lit, 42]]
        else
          [type, var, [:nil]]
        end
      end
    end

    # Swaps for a :while node.
    def mutate_until(node)
      [:while, node[1], node[2], node[3]]
    end

    # Replaces the value of the cvasgn with nil if its some value, and 42 if its
    # nil.
    alias mutate_cvasgn mutate_asgn

    # Replaces the value of the dasgn with nil if its some value, and 42 if its
    # nil.
    alias mutate_dasgn mutate_asgn

    # Replaces the value of the dasgn_curr with nil if its some value, and 42 if
    # its nil.
    alias mutate_dasgn_curr mutate_asgn

    # Replaces the value of the iasgn with nil if its some value, and 42 if its
    # nil.
    alias mutate_iasgn mutate_asgn

    # Replaces the value of the gasgn with nil if its some value, and 42 if its
    # nil.
    alias mutate_gasgn mutate_asgn

    # Replaces the value of the lasgn with nil if its some value, and 42 if its
    # nil.
    alias mutate_lasgn mutate_asgn

    # Replaces the value of the :lit node with a random value.
    def mutate_lit(exp)
      case exp[1]
      when Fixnum, Float, Bignum
        [:lit, exp[1] + rand_number]
      when Symbol
        [:lit, rand_symbol]
      when Regexp
        [:lit, Regexp.new(Regexp.escape(rand_string.gsub(/\//, '\\/')))]
      when Range
        [:lit, rand_range]
      end
    end

    def rand_string
      alpha = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      buf = ""
      rand(50).times do
        buf << alpha[rand(alpha.size)]
      end
      buf
    end

    # Replaces the value of the :str node with a random value.
    def mutate_str(node)
      [:str, rand_string]
    end

    # Swaps the then and else parts of the :if node.
    def mutate_if(node)
      [:if, node[1], node[3], node[2]]
    end

    # Swaps for a :false node.
    def mutate_true(node)
      [:false]
    end

    # Swaps for a :true node.
    def mutate_false(node)
      [:true]
    end

    # Swaps for a :until node.
    def mutate_while(node)
      [:until, node[1], node[2], node[3]]
    end
  end
end
