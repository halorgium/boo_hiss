module BooHiss
  describe "the Mutator" do
    before(:each) do
      @mutation = MockMutation.new
    end
    
    def should_mutate(kind, val)
      result = Mutator.run(@mutation, parse(val.inspect))
      result.first.should == kind
      result.should_not == s(kind, val)
    end
    
    describe "mutating a string" do
      it "returns a random string" do
        should_mutate(:str, "test")
      end
    end
    
    describe "mutating a Number" do
      it "for a Fixnum, returns a random Fixnum" do
        should_mutate(:lit, 1)
      end
      
      it "for a Float, returns a random Float" do
        should_mutate(:lit, 1.7)
      end
      
      it "for a Bignum, returns a random Bignum" do
        should_mutate(:lit, 2 ** 100)
      end
    end
    
    describe "mutating a Symbol" do
      it "returns a random symbol" do
        should_mutate(:lit, :foo)
      end
    end
    
    describe "mutating a Regexp" do
      it "returns a random regexp" do
        should_mutate(:lit, /awesome/)
      end
    end
    
    describe "mutating a Range" do
      it "returns a random range" do
        should_mutate(:lit, 1..2)
      end
    end
    
    describe "mutating an If" do
      it "replaces and if with an unless" do
        @mutation = MockMutation.new(:if)
        result = Mutator.run(@mutation, parse("if true; 10; end"))
        result[2].should == nil
        result[3].should == s(:lit, 10)
      end
      
      it "replaces an unless with an if" do
        @mutation = MockMutation.new(:if)
        result = Mutator.run(@mutation, parse("unless true; 10; end"))
        result[2].should == s(:lit, 10)
        result[3].should == nil
      end
    end
    
    describe "mutating a Boolean" do
      it "replaces a true with a false" do
        should_mutate(:false, true)
      end
      
      it "replaces a false with a true" do
        should_mutate(:true, false)
      end
    end
    
    describe "mutating a method" do
      it "removes the body of the method" do
        @mutation = MockMutation.new(:defn)
        result = Mutator.run(@mutation, parse("def foo; 10; end"))
        result.last.should == s(:scope, s(:block, s(:args), s(:nil)))
      end
    end
    
    describe "mutating a call"
  end
end