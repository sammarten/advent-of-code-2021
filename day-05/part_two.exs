defmodule HydrothermalVenture do
  def run(input_path \\ "input.txt") do
    input_path
    |> parse_coordinates()
    |> plot_lines()
    |> count_dangerous_areas()
  end

  def parse_coordinates(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(
      fn line -> 
        [start_point, _, end_point] = String.split(line, " ")
        {parse_point(start_point), parse_point(end_point)}
      end)
  end

  def parse_point(point) do
    [x, y] = String.split(point, ",")
    {String.to_integer(x), String.to_integer(y)}
  end

  def plot_lines(coordinates) do
    Enum.reduce(
      coordinates,
      %{},
      fn
        {{x, y1}, {x, y2}}, map -> plot_vertical_line(x, y1, y2, map)
        {{x1, y}, {x2, y}}, map -> plot_horizontal_line(y, x1, x2, map)
        {{x1, y1}, {x2, y2}}, map -> plot_diagonal_line(x1, y1, x2, y2, map)
      end)
  end

  def plot_vertical_line(x, y1, y2, map) do
    Enum.reduce(
      y1..y2,
      map,
      &Map.update(&2, {x, &1}, 1, fn val -> val + 1 end))
  end

  def plot_horizontal_line(y, x1, x2, map) do
    Enum.reduce(
      x1..x2,
      map,
      &Map.update(&2, {&1, y}, 1, fn val -> val + 1 end))
  end

  def plot_diagonal_line(x1, y1, x2, y2, map) do
    [x1..x2, y1..y2]
    |> Enum.zip()
    |> Enum.reduce(
      map,
      fn {x, y}, map_acc -> 
        Map.update(map_acc, {x, y}, 1, fn val -> val + 1 end)
      end)
  end

  def count_dangerous_areas(map) do
    map
    |> Enum.filter(fn {_key, val} -> val >= 2 end)
    |> length()
  end
end

IO.inspect(HydrothermalVenture.run())
