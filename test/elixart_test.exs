defmodule ElixartTest do
  use ExUnit.Case
  import Elixart
  doctest Elixart

  test "capitalize" do
    assert capitalize("name") == "Name"
    assert capitalize("name second") == "Name Second"
  end

  test "calculate increment" do
    inc = fn(x) -> x + 1 end
    assert calculate(job: inc, wc: 1, hc: 0, init: 0) == 1
    assert calculate(job: inc, wc: 1, hc: 1, init: 0) == 2
    assert calculate(job: inc, wc: 1, hc: 2, init: 0) == 3
    assert calculate(job: inc, wc: 1, hc: 2, init: 1) == 4
  end

  test "calculate double" do
    double = fn(x) -> x * 2 end
    assert calculate(job: double, wc: 1, hc: 0, init: 0) == 0
    assert calculate(job: double, wc: 1, hc: 0, init: 1) == 2
    assert calculate(job: double, wc: 1, hc: 1, init: 1) == 4
  end
end
