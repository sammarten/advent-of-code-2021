defmodule SmokeBasin do
  def run(input_path \\ "input.txt") do
    input_path
    |> create_heightmap()
    |> find_low_points()
    |> calc_risk_levels()
  end

  def create_heightmap(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.map(&1, fn grapheme -> String.to_integer(grapheme) end))
    |> Stream.with_index()
    |> Enum.reduce(
      %{},
      fn {line, row_number}, row_acc ->
        line
        |> Stream.with_index()
        |> Enum.reduce(
          row_acc,
          fn {height, col_number}, col_acc ->
            Map.put(col_acc, {row_number, col_number}, height)
          end)
      end)
  end

  def find_low_points(heightmap) do
    heightmap
    |> Map.keys()
    |> Enum.reduce(%{heightmap: heightmap, low_points: []}, &check_for_low_point(&1, &2))
    |> Map.get(:low_points)
    |> Enum.map(&Map.get(heightmap, &1))
  end

  def check_for_low_point(point, %{heightmap: heightmap, low_points: low_points} = acc) do
    min_surrounding_height =
      find_surrounding(point, heightmap)
      |> Enum.map(&Map.get(heightmap, &1))
      |> Enum.min()

    if Map.get(heightmap, point) < min_surrounding_height do
      %{acc | low_points: [point | low_points]}
    else
      acc
    end
  end

  def find_surrounding({x, y}, heightmap) do
    [{x, y - 1}, {x - 1, y}, {x + 1, y}, {x, y + 1}]
    |> Enum.reject(&is_nil(Map.get(heightmap, &1)))
  end

  def calc_risk_levels(low_points) do
    low_points
    |> Stream.map(&(&1 + 1))
    |> Enum.sum()
  end
end

IO.inspect(SmokeBasin.run())
