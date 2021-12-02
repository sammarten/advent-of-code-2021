defmodule Dive do
  def run do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.reduce(%{horizontal: 0, depth: 0},
      fn
        "forward " <> h, %{horizontal: horizontal} = acc ->
          %{acc | horizontal: horizontal + String.to_integer(h)}

        "down " <> d, %{depth: depth} = acc ->
          %{acc | depth: depth + String.to_integer(d)}

        "up " <> d, %{depth: depth} = acc ->
          %{acc | depth: depth - String.to_integer(d)}
      end)
    |> horizontal_times_depth()
  end

  def horizontal_times_depth(%{horizontal: horizontal, depth: depth}), do: horizontal * depth
end

IO.inspect(Dive.run())
