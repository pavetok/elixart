defmodule Elixart do

  def hello do
    "Hello World"
  end

  def capitalize(str) do
    Enum.map_join(String.split(str) , " ", fn word -> String.capitalize(word) end)
  end

  def calculate(job: job,
                wc: wc,
                hc: hc,
                init: init) do
    send self(), {:result, job.(init) + hc}
    receive do
      {:result, value} -> value
    after
      500 -> raise "Something went wrong."
    end
  end
end
