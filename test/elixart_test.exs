defmodule ElixartTest do
  use ExUnit.Case
  import Elixart
  doctest Elixart

  test "capitalize" do
    assert capitalize("name") == "Name"
    assert capitalize("name second") == "Name Second"
  end

  test "ping pong" do
    pid = spawn_link(Elixart, :pong, [])
    send pid, {:ping, self()}
    assert_receive :pong
  end

  test "stateful ping pong" do
    pid = spawn_link(Elixart, :stateful, [nil])
    send pid, {:address, self()}
    # first
    send pid, :ping
    assert_receive :pong
    # second
    send pid, :ping
    assert_receive :pong
  end

  test "calculate increment" do
    inc = fn(x) -> x + 1 end
    assert calculate(job: inc, wc: 1, hc: 0, init: 0) == 1
    assert calculate(job: inc, wc: 1, hc: 1, init: 0) == 2
    assert calculate(job: inc, wc: 1, hc: 2, init: 0) == 3
    assert calculate(job: inc, wc: 1, hc: 2, init: 1) == 4
    assert calculate(job: inc, wc: 10, hc: 20, init: 10) == 31
  end

  test "calculate double" do
    double = fn(x) -> x * 2 end
    assert calculate(job: double, wc: 1, hc: 0, init: 0) == 0
    assert calculate(job: double, wc: 5, hc: 5, init: 0) == 0
    assert calculate(job: double, wc: 1, hc: 0, init: 1) == 2
    assert calculate(job: double, wc: 1, hc: 1, init: 1) == 4
    assert calculate(job: double, wc: 2, hc: 0, init: 1) == 2
    assert calculate(job: double, wc: 2, hc: 1, init: 1) == 4
    assert calculate(job: double, wc: 2, hc: 2, init: 1) == 8
    assert calculate(job: double, wc: 2, hc: 3, init: 1) == 16
  end


end
