defmodule PassagePathing do
  def run do
    "input.txt"
    |> read_conns()
    |> IO.inspect()
    |> determine_paths()
  end

  defp read_conns(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, &add_conn_to_map/2)
  end

  defp add_conn_to_map([a, b], conns) do
    a_conns = Map.get(conns, a, [])
    b_conns = Map.get(conns, b, [])

    conns
    |> Map.put(a, [b | a_conns])
    |> Map.put(b, [a | b_conns])
  end

  defp determine_paths(conns) do
    "start"
    |> move_to_next_cave(conns, [], [], false)
    |> remove_dead_ends()
  end

  defp move_to_next_cave("end", _conns, path, _visited_small_caves, _revisited_small_cave?) do
    [Enum.reverse(path) ++ ["end"]]
  end

  defp move_to_next_cave(cave, conns, path, visited_small_caves, revisited_small_cave?) do
    updated_path = [cave | path]

    [possible_caves, updated_revisited_small_cave?] =
      case [cave in visited_small_caves, revisited_small_cave?] do
        [true, true] ->
          [[], true]

        [true, false] ->
          [Map.get(conns, cave) -- visited_small_caves -- ["start"], true]

        [false, true] ->
          [Map.get(conns, cave)  -- ["start"], true]

        [false, false] ->
          [Map.get(conns, cave) -- ["start"], false]
      end

    updated_visited_small_caves =
      if small_cave?(cave) do
        Enum.uniq([cave | visited_small_caves])
      else
        visited_small_caves
      end

    case possible_caves do
      [] ->
        []

      available_caves ->
        Enum.flat_map(available_caves, &move_to_next_cave(&1, conns, updated_path, updated_visited_small_caves, updated_revisited_small_cave?))
    end
  end

  defp remove_dead_ends(paths) do
    Enum.reject(paths, &is_nil/1)
  end

  defp small_cave?(name), do: name == String.downcase(name)
end

paths = PassagePathing.run()
IO.inspect(paths)
IO.puts("#{length(paths)} paths")
