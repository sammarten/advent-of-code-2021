defmodule Lanternfish do
  @days_to_simulate 256
  @gestation_age 6
  @newborn_age 8

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
    |> Enum.group_by(&(&1))
    |> Enum.map(fn {day, lanternfish} -> {day, length(lanternfish)} end)
    |> Enum.into(%{})
  end

  def simulate_days(lanternfish) do
    Enum.reduce(1..@days_to_simulate, lanternfish, &simulate_day/2)
  end

  def simulate_day(day, lanternfish) do
    Enum.reduce(
      lanternfish, 
      Enum.reduce(0..@newborn_age, %{}, &Map.put(&2, &1, 0)),
      fn
        {0, zero_count}, %{6 => six_count} = acc -> 
          acc
          |> Map.put(@gestation_age, zero_count + six_count)
          |> Map.put(@newborn_age, zero_count)

        {7, seven_count}, %{6 => six_count} = acc -> 
          Map.put(acc, 6, seven_count + six_count)

        {day, count}, acc ->
          Map.put(acc, day - 1, count)
      end)
  end

  def count_lanternfish(lanternfish) do
    lanternfish
    |> Enum.map(fn {_days_left, count} -> count end)
    |> Enum.sum()
  end
end

IO.inspect(Lanternfish.run())
