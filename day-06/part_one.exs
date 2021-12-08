defmodule Lanternfish do
  @days_to_simulate 256

  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> simulate_days()
    |> count_lanternfish()
  end

  def read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def simulate_days(lanternfish) do
    %{existing: existing, new: new} =
      Enum.reduce(1..@days_to_simulate, %{existing: lanternfish, new: []}, &simulate_day/2)
    
    existing ++ new
  end

  def simulate_day(day, %{existing: existing, new: new}) do
    Enum.reduce(
      existing ++ new, 
      %{existing: [], new: []},
      fn
        0, %{existing: existing_acc, new: new_acc} ->
          %{existing: [6 | existing_acc], new: [8 | new_acc]}

        days, %{existing: existing_acc} = acc ->
          %{acc | existing: [days - 1 | existing_acc]}
      end)
  end

  def count_lanternfish(lanternfish), do: length(lanternfish)
end

IO.inspect(Lanternfish.run("test_input.txt"))
