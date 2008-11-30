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
