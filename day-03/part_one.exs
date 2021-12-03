defmodule BinaryDiagnostic do
  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> calc_frequencies()
    |> calc_power_consumption()
  end

  defp read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.map(&1, fn str -> String.to_integer(str) end))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp calc_frequencies([first_row | _] = data) do
    row_count = length(first_row)

    data
    |> Enum.map(&Enum.sum/1)
    |> Enum.map(&(&1 / row_count))
  end

  defp calc_power_consumption(frequencies) do
    [gamma_rate, epsilon_rate] =
      Enum.map(
        [&gamma_rate_mask/1, &epsilon_rate_mask/1],
        &calc_rate(frequencies, &1)
      )

    gamma_rate * epsilon_rate
  end

  defp gamma_rate_mask(value), do: round(value)

  defp epsilon_rate_mask(value), do: round(1 - value)

  defp calc_rate(frequencies, mask_fn) do
    frequencies
    |> Enum.map(mask_fn)
    |> Enum.map(&to_string/1)
    |> Enum.join()
    |> String.to_integer(2)
  end

end

IO.inspect(BinaryDiagnostic.run())
