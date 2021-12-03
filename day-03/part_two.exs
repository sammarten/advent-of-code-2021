defmodule BinaryDiagnostic do
  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> calc_life_support_rating()
  end

  defp read_input(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.map(&1, fn str -> String.to_integer(str) end))
  end

  defp calc_life_support_rating(numbers) do
    [&oxygen_generator_filter/1, &co2_scrubber_filter/1]
    |> Enum.map(&calc_ratings(numbers, &1))
    |> Enum.product()
  end

  defp oxygen_generator_filter(bits) do
    round(calc_bit_average(bits))
  end

  defp co2_scrubber_filter(bits) do
    if calc_bit_average(bits) < 0.5, do: 1, else: 0
  end

  defp calc_bit_average(bits) do
    bits
    |> Enum.sum() 
    |> Kernel./(length(bits))
  end

  defp calc_ratings([first_number | _] = numbers, filter_fn) do
    bit_count = length(first_number)

    0..bit_count - 1
    |> Enum.reduce_while(
      numbers,
      fn bit_position, remaining_numbers ->
        filter_bit_value = 
          remaining_numbers
          |> get_bit_values_at_position(bit_position)
          |> filter_fn.()

        case calc_remaining_numbers(remaining_numbers, bit_position, filter_bit_value) do
          [last_number] -> {:halt, calc_rating(last_number)}
          updated_remaining_numbers -> {:cont, updated_remaining_numbers}  
        end
      end)
  end

  defp get_bit_values_at_position(numbers, bit_position) do
    Enum.map(numbers, &Enum.at(&1, bit_position))
  end

  defp calc_remaining_numbers(numbers, bit_position, filter_value) do
    Enum.filter(numbers, &(Enum.at(&1, bit_position) == filter_value))
  end

  defp calc_rating(bits) do
    bits
    |> Enum.join()
    |> String.to_integer(2)
  end
end

IO.inspect(BinaryDiagnostic.run())
