defmodule TheTreacheryOfWhales do
  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> find_horizontal_position()
  end

  def read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def find_horizontal_position(positions) do
    {min, max} = Enum.min_max(positions)
    Enum.reduce(min..max, nil, &calc_min_fuel_consumption(&1, positions, &2))
  end

  def calc_min_fuel_consumption(position, positions, nil) do
    calc_fuel_consumption(position, positions)
  end

  def calc_min_fuel_consumption(position, positions, current_min) do
    fuel_consumption = calc_fuel_consumption(position, positions)
    if fuel_consumption < current_min, do: fuel_consumption, else: current_min
  end

  def calc_fuel_consumption(position, positions) do
    positions
    |> Enum.map(&abs(&1 - position))
    |> Enum.sum()
  end
end

IO.inspect(TheTreacheryOfWhales.run())
