module BooHiss
  describe Reaper do
    def locate_in(string)
      sexp = ParseTree.new.parse_tree_for_string(string)
      Reaper.locate_in(sexp.first)
    end

    describe "with a single string" do
      it "finds the string mutation" do
        reaper = locate_in('"test"')
        reaper.mutations.should == [[:str, "test"]]
      end
    end

    describe "with a method with an if and a few lit and str" do
      it "finds the string mutation" do
        reaper = locate_in <<-EOT
          def foo(a, b)
            if a == 1
              "awesome"
            else
              "\#{b} - yes!"
            end
          end
        EOT
        reaper.mutations.should ==
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

