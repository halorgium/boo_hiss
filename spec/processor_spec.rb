class Handler
  def handle(node)
    sexp = Sexp.from_array(node)
    nodes << sexp
    sexp
  end

  def nodes
    @node ||= []
  end
end

module BooHiss
  describe Processor do
    def process(string)
      mutator = Handler.new
      processor = Processor.new(mutator)
      processor.process(parse(string))
      mutator
    end

    it "mutates call" do
      pending "Need to figure out how to get a 'call' working"
      mutator = process <<-EOT
        x.y { 1 }
      EOT
#        def m; end
#        def foo; m + 1; end
#      EOT
      mutator.nodes.should == [1]
    end

    it "mutates defn" do
      mutator = process('def foo; end')
      mutator.nodes.should == [s(:defn, :foo, s(:scope, s(:block, s(:args), s(:nil))))]
    end

    it "mutates cvasgn" do
      pending "Need to figure out how to get a 'cvasgn' working; currently generates a 'cvdecl'"
      mutator = process('@@a = 1; @@a = nil')
      mutator.nodes.should == [s(:cvasgn, :@@a, s(:nil))]
    end

    it "mutates dasgn" do
      mutator = process <<-EOT
        foo { y = nil; bar { y = nil } }
      EOT
      mutator.nodes.last.should == s(:dasgn, :y, s(:nil))
    end

    it "mutates dasgn_curr" do
      mutator = process <<-EOT
        foo { a = nil }
      EOT
      mutator.nodes.should == [s(:dasgn_curr, :a, s(:nil))]
    end

    it "mutates iasgn" do
      mutator = process('@a = nil')
      mutator.nodes.should == [s(:iasgn, :@a, s(:nil))]
    end

    it "mutates gasgn" do
      mutator = process('$a = nil')
      mutator.nodes.should == [s(:gasgn, :$a, s(:nil))]
    end

    it "mutates lasgn" do
      mutator = process('a = nil')
      mutator.nodes.should == [s(:lasgn, :a, s(:nil))]
    end

    it "mutates lit" do
      mutator = process('1')
      mutator.nodes.should == [s(:lit, 1)]
    end

    it "mutates str" do
      mutator = process('"test string"')
      mutator.nodes.should == [s(:str, "test string")]
    end

    it "mutates if" do
      mutator = process('if nil; end')
      mutator.nodes.should == [s(:if, s(:nil), nil, nil)]
    end

    it "mutates true" do
      mutator = process('true')
      mutator.nodes.should == [s(:true)]
    end

    it "mutates false" do
      mutator = process('false')
      mutator.nodes.should == [s(:false)]
    end

    it "mutates while" do
      mutator = process('while nil; end')
      mutator.nodes.should == [s(:while, s(:nil), nil, true)]
    end

    it "mutates until" do
      mutator = process('until nil; end')
      mutator.nodes.should == [s(:until, s(:nil), nil, true)]
    end
  end
end
