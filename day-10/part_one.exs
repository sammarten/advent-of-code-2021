defmodule SyntaxScoring do
  @illegal_char_scores %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> calc_syntax_error_score()
  end

  def read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def calc_syntax_error_score(lines) do
    lines
    |> Enum.map(&parse_line(&1, []))
    |> Enum.sum()
  end

  def parse_line([], _), do: 0

  def parse_line([opening_bracket | rest], stack) when opening_bracket in ["(", "[", "{", "<"] do
    parse_line(rest, [opening_bracket | stack])
  end

  def parse_line([")" | rest], ["(" | stack]), do: parse_line(rest, stack)
  def parse_line(["]" | rest], ["[" | stack]), do: parse_line(rest, stack)
  def parse_line(["}" | rest], ["{" | stack]), do: parse_line(rest, stack)
  def parse_line([">" | rest], ["<" | stack]), do: parse_line(rest, stack)

  def parse_line([closing_bracket | _], _), do: Map.get(@illegal_char_scores, closing_bracket)
end

IO.inspect(SyntaxScoring.run())
