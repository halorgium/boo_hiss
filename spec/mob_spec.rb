module BooHiss
  class SimpleConditionWithTwoStrings
    def initialize(a, b)
      @a, @b = a, b
    end

    def same?
      if @a == @b
        "yes"
      else
        "no"
      end
    end
  end

  describe "Starting a", Mob do
    def start_mob_for(klass, method_name, &block)
      @reporter = SilentReporter.new
      tester = ExampleGroup::Tester.new(klass, method_name, &block)
      Mob.new(klass, method_name, tester, @reporter)
    end

    describe "with", SimpleConditionWithTwoStrings do
      before(:all) do
        mob = start_mob_for(SimpleConditionWithTwoStrings, :same?) do
          describe "When the arguments are the same" do
            it "returns 'yes'" do
              i = SimpleConditionWithTwoStrings.new(2, 2)
              i.same?.should == "yes"
            end
          end

          describe "When the arguments are different" do
            it "returns 'no'" do
              i = SimpleConditionWithTwoStrings.new(2, 1)
              i.same?.should == "no"
            end
          end
        end
        mob.enrage
      end

      it "detects 5 mutation points" do
        @reporter.mutation_count.should == 5
      end

      it "passes the initial test run" do
        @reporter.initial_test_result.should be_true
      end

      it "has no eval exceptions" do
        @reporter.mutations.values.map {|m| m.exception_in_eval}.compact.should be_empty
      end

      it "has no test exceptions" do
        @reporter.mutations.values.map {|m| m.exception_in_test}.compact.should be_empty
      end

      it "fails all mutation test runs" do
        @reporter.mutations.values.any? {|m| m.result}.should be_false
      end
    end
  end
end
