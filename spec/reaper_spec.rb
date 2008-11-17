module BooHiss
  describe Reaper do
    describe "with a single string" do
      it "finds the string mutation" do
        mutations = Reaper.locate_in(parse('"test"'))
        mutations.should == [[:str, "test"]]
      end
    end

    describe "with a method with an if and a few lit and str" do
      it "finds the string mutation" do
        sexp = parse <<-EOT
          def foo(a, b)
            if a == 1
              "awesome"
            else
              "\#{b} - yes!"
            end
          end
        EOT
        mutations = Reaper.locate_in(sexp)
        mutations.should ==
          [[:lit, 1],
           [:call, s(:lvar, s(:a)), :==, s(:array, s(:lit, 1))],
           [:str, "awesome"],
           [:str, " - yes!"],
           [:if,
            s(:call, s(:lvar, s(:a)), :==, s(:array, s(:lit, 1))),
            s(:str, "awesome"),
            s(:dstr, s(""), s(:evstr, s(:lvar, s(:b))), s(:str, " - yes!"))],
           [:defn,
            :foo,
            s(:scope,
             s(:block,
              s(:args, s(:a), s(:b)),
              s(:if,
               s(:call, s(:lvar, s(:a)), :==, s(:array, s(:lit, 1))),
               s(:str, "awesome"),
               s(:dstr, s(""), s(:evstr, s(:lvar, s(:b))), s(:str, " - yes!")))))]]
      end
    end
  end
end

