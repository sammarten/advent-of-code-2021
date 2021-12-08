defmodule SevenSegmentSearch do
  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> scan_output_values()
  end

  def read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [input, output] = String.split(line, " | ")

    %{
      input: String.split(input, " ", trim: true),
      output: String.split(output, " ", trim: true)
    }
  end

  def scan_output_values(lines) do
    lines
    |> Enum.map(&Map.get(&1, :output))
    |> List.flatten()
    |> Enum.filter(&(String.length(&1) in [2, 3, 4, 7]))
    |> Enum.count()
  end
end

IO.inspect(SevenSegmentSearch.run())
