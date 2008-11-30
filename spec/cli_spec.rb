describe "Invoking the CLI inside 'fixtures/condition_with_two_strings'" do
  describe "with: -r lib/impl -R simple SimpleConditionWithTwoStrings#same?" do
    before(:all) do
      @old_cwd = Dir.pwd
      Dir.chdir(File.dirname(__FILE__) + '/../fixtures/condition_with_two_strings')
    end

    after(:all) do
      Dir.chdir(@old_cwd)
    end

    before(:all) do
      argv = ['-r', 'lib/impl', '-R', 'silent', 'SimpleConditionWithTwoStrings#same?', 'spec/impl_spec.rb']
      @reporter = BooHiss::CLI.run(argv)
    end

    it "detects 5 mutation points" do
      @reporter.mutation_count.should == 5
    end

    it "passes the initial test run" do
      @reporter.initial_test_result.should be_true
    end

    it "has no eval exceptions" do
      @reporter.mutations_with_eval_exceptions.should be_empty
    end

    it "has no test exceptions" do
      @reporter.mutations_with_test_exceptions.should be_empty
    end

    it "fails all mutation test runs" do
      @reporter.unsuccessful_mutations.should be_empty
    end
  end
end
