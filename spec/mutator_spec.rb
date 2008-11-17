module BooHiss
  describe "the Mutator" do
    describe "mutating a string" do
      it "returns a random string" do
        mutation = Mutation.new
        result = Mutator.run(mutation, parse("\"test\""))
        result.first.should == :str
        result.should_not == s(:str, "test")
      end
    end
  end
end