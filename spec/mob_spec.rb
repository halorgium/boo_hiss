module BooHiss
  describe "Mutating a class method" do
    before(:each) do
      @m = Mob.new(class << FixtureClasses::EmptyMethod; self; end, :a_class_method)
    end

    it "is represented as a Sexp" do
      @m.exp.should == [:defn, :a_class_method, [:scope, [:args]]]
    end
  end

  describe "Mutating an instance method" do
    before(:each) do
      @m = Mob.new(FixtureClasses::EmptyMethod, :an_instance_method)
    end

    it "is represented as a Sexp" do
      @m.exp.should == [:defn, :an_instance_method, [:scope, [:block, [:args], [:nil]]]]
    end
  end
end
