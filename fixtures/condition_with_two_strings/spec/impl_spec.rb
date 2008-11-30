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
