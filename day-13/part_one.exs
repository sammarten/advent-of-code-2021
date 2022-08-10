defmodule TransparentOrigami do
  def run do
    "input.txt"
    |> read_file()
    |> apply_folds()
    |> count_dots()
  end

  defp read_file(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.reduce(%{dots: %{}, folds: []}, fn
      [""], acc -> acc
      ["fold along " <> fold], %{folds: folds} = acc -> %{acc | folds: folds ++ [parse_fold(fold)]}
      coords, %{dots: dots} = acc -> %{acc | dots: Map.put(dots, parse_dot(coords), true)}
    end)
  end

  defp parse_dot([x, y]) do
    {String.to_integer(x), String.to_integer(y)}
  end

  defp parse_fold(fold) do
    [axis, line] = String.split(fold, "=")
    {axis, String.to_integer(line)}
  end

  defp apply_folds(%{dots: dots, folds: [fold | _remaining_folds]}) do
    Enum.reduce([fold], dots, &fold_paper(&1, &2))
  end

  defp fold_paper({"x", line}, dots) do
    fold_vertical(line, dots)
  end

  defp fold_paper({"y", line}, dots) do
    fold_horizontal(line, dots)
  end

  defp fold_vertical(line, dots) do
    Enum.reduce(dots, dots, 
      fn 
        {{x, y}, _}, acc when x > line ->
          acc
          |> Map.delete({x, y})
          |> Map.put({calc_reflection(x, line), y}, true)

        _, acc ->
          acc
      end)
  end

  defp fold_horizontal(line, dots) do
    Enum.reduce(dots, dots, 
      fn 
        {{x, y}, _}, acc when y > line ->
          acc
          |> Map.delete({x, y})
          |> Map.put({x, calc_reflection(y, line)}, true)

        _, acc ->
          acc
      end)
  end

  defp calc_reflection(p, line) do
    line - (p - line)
  end

  defp count_dots(dots), do: Enum.count(dots)

  # defp draw_paper(%{dots: dots}) do
  #   max_x =
  #     dots
  #     |> Enum.map(fn {{x, _y}, _} -> x end)
  #     |> Enum.max()

  #   max_y =
  #     dots
  #     |> Enum.map(fn {{_x, y}, _} -> y end)
  #     |> Enum.max()    
  # end
end

IO.inspect(TransparentOrigami.run())