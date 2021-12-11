defmodule SmokeBasin do
  def run(input_path \\ "input.txt") do
    input_path
    |> create_heightmap()
    |> find_low_points()
    |> build_basins()
    |> multiply_three_largest()
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

  def build_basins(%{heightmap: heightmap, low_points: low_points}) do
    Enum.map(low_points, &build_basin(heightmap, &1))
  end

  def build_basin(heightmap, point) do
    new_points =
      find_surrounding(point, heightmap)
      |> Enum.filter(&((Map.get(heightmap, &1) > Map.get(heightmap, point)) && Map.get(heightmap, &1) < 9))
      |> Enum.uniq()

    build_basin(heightmap, new_points, Enum.uniq([point | new_points]))
  end

  def build_basin(_, [], basin), do: length(basin)
  def build_basin(heightmap, points, basin) do
    new_points =
      points
      |> Enum.map(fn point ->
          find_surrounding(point, heightmap)
          |> Enum.filter(&((Map.get(heightmap, &1) > Map.get(heightmap, point)) && Map.get(heightmap, &1) != 9))
          |> List.flatten()
        end)
      |> List.flatten()
      |> Enum.uniq()

    build_basin(heightmap, new_points, Enum.uniq(basin ++ new_points))
  end

  def multiply_three_largest(basins) do
    basins
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def find_surrounding({x, y}, heightmap) do
    [{x, y - 1}, {x - 1, y}, {x + 1, y}, {x, y + 1}]
    |> Enum.reject(&is_nil(Map.get(heightmap, &1)))
  end
end

IO.inspect(SmokeBasin.run())
