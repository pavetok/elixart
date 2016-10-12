defmodule ElixartTest do
  use ExUnit.Case
  import Elixart
  doctest Elixart

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "hello" do
    assert hello == "Hello Worl"
  end

  test "capitalize" do
    assert capitalize("name") == "Name"
    assert capitalize("name second") == "Name Second"
  end
end
