defmodule GiantSquid do
  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> parse_input()
    |> play_bingo()
  end

  def read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
  end

  def parse_input([numbers | boards]) do
    %{
      boards: parse_boards(boards),
      numbers: parse_numbers(numbers)
    }
  end

  def parse_numbers(numbers) do
    String.split(numbers, ",")
  end

  def parse_boards(boards) do
    boards
    |> Enum.reject(&(&1 == ""))
    |> Enum.chunk_every(5, 5)
    |> Enum.map(&parse_board/1)
  end

  def parse_board(board) do
    rows =
      board
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))

    %{
      rows: rows,
      cols: cols_from_rows(rows)
    }
  end

  defp cols_from_rows(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end


  def play_bingo(%{boards: boards, numbers: numbers}) do
    Enum.reduce_while(
      numbers,
      [],
      fn number, played_numbers ->
        updated_played_numbers = [number | played_numbers]

        if length(updated_played_numbers) >= 5 do
          case check_for_winner(boards, updated_played_numbers) do
            [winning_board] ->
              {:halt, calc_winning_score(winning_board, updated_played_numbers, number)}

            [] ->
              {:cont, updated_played_numbers}
          end
        else
          {:cont, updated_played_numbers}
        end
      end)
  end

  def check_for_winner(boards, played_numbers) do
    Enum.filter(boards, &(has_winning_row?(&1, played_numbers) || has_winning_column?(&1, played_numbers)))
  end

  def has_winning_row?(%{rows: rows}, played_numbers) do
    Enum.reduce_while(
      rows,
      false,
      fn row, _ ->
        if row -- played_numbers == [] do
          {:halt, true}
        else
          {:cont, false}
        end
      end)
  end

  def has_winning_column?(%{cols: cols}, played_numbers) do
    Enum.reduce_while(
      cols,
      false,
      fn col, _ ->
        if col -- played_numbers == [] do
          {:halt, true}
        else
          {:cont, false}
        end
      end)
  end

  def calc_winning_score(%{cols: cols, rows: rows}, played_numbers, last_number) do
    rows ++ cols
    |> List.flatten()
    |> Enum.uniq()
    |> Kernel.--(played_numbers)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> Kernel.*(String.to_integer(last_number))
  end
end

IO.inspect(GiantSquid.run())
