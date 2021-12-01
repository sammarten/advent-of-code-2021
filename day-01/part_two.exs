defmodule SonarSweep do
  def run do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn [first, second, third] -> first + second + third end)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [first, second] -> second > first end)
    |> length()
  end
end

IO.puts(SonarSweep.run())
