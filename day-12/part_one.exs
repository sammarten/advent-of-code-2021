defmodule PassagePathing do
  def run do
    "test_input.txt"
    |> read_connections()
    |> determine_paths()
  end

  defp read_connections(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, &add_connection_to_map/2)
  end

  defp add_connection_to_map([a, b], connections) do
    a_connections = Map.get(connections, a, [])
    b_connections = Map.get(connections, b, [])

    connections
    |> Map.put(a, [b | a_connections])
    |> Map.put(b, [a | b_connections])
  end

  defp determine_paths(connections) do
    determine_paths(
      connections,
      Map.get(connections, "start"),
      []
    )
  end

  def determine_paths(connections, caves, visited_caves) do
    caves
    |> Enum.find_cave_paths()
  end

  def big_cave?(name), do: name == String.upcase(name)
  def small_cave?(name), do: name == String.downcase(name)
end

IO.inspect(PassagePathing.run())
