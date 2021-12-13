defmodule SyntaxScoring do
  @autocomplete_char_scores %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> calc_autocomplete_scores()
    |> get_middle_score()
  end

  def read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def calc_autocomplete_scores(lines) do
    lines
    |> Enum.map(&parse_line(&1, []))
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&autocomplete_line(&1))
  end

  def parse_line([], stack), do: stack

  def parse_line([opening_bracket | rest], stack) when opening_bracket in ["(", "[", "{", "<"] do
    parse_line(rest, [opening_bracket | stack])
  end

  def parse_line([")" | rest], ["(" | stack]), do: parse_line(rest, stack)
  def parse_line(["]" | rest], ["[" | stack]), do: parse_line(rest, stack)
  def parse_line(["}" | rest], ["{" | stack]), do: parse_line(rest, stack)
  def parse_line([">" | rest], ["<" | stack]), do: parse_line(rest, stack)

  def parse_line(_, _), do: nil

  def autocomplete_line(line) do
    Enum.reduce(line, 0, fn char, score_acc ->
      (5 * score_acc) + Map.get(@autocomplete_char_scores, char)
    end)
  end

  def get_middle_score(scores) do
    middle_index = round((length(scores) - 1) / 2)

    scores
    |> Enum.sort()
    |> Enum.at(middle_index)
  end
end

IO.inspect(SyntaxScoring.run())
