defmodule Dive do
  def run do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.reduce(%{horizontal: 0, depth: 0, aim: 0},
      fn
        "forward " <> f, %{horizontal: horizontal, depth: depth, aim: aim} = acc ->
          f = String.to_integer(f)
          %{acc | horizontal: horizontal + f, depth: depth + (aim * f)}

        "down " <> a, %{aim: aim} = acc ->
          %{acc | aim: aim + String.to_integer(a)}

        "up " <> a, %{aim: aim} = acc ->
          %{acc | aim: aim - String.to_integer(a)}
      end)
    |> horizontal_times_depth()
  end

  def horizontal_times_depth(%{horizontal: horizontal, depth: depth}), do: horizontal * depth
end

IO.inspect(Dive.run())
