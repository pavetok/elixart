defmodule Elixart do

  def hello do
    "Hello World"
  end

  def capitalize(str) do
    Enum.map_join(String.split(str) , " ", fn word -> String.capitalize(word) end)
  end
end
