defmodule DumboOctopus do
  @flash_threshold 9
  @steps_to_run 100

  def run(input_path \\ "input.txt") do
    input_path
    |> read_energy_levels()
    |> run_steps()
  end

  def read_energy_levels(input_path) do
    input_path
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.map(&1, fn grapheme -> String.to_integer(grapheme) end))
    |> Stream.with_index()
    |> Enum.reduce(
      %{},
      fn {line, row_number}, row_acc ->
        line
        |> Stream.with_index()
        |> Enum.reduce(
          row_acc,
          fn {energy_level, col_number}, col_acc ->
            Map.put(col_acc, {row_number, col_number}, %{energy_level: energy_level, flashed?: false})
          end)
      end)
  end

  def run_steps(energy_levels) do
    %{flash_count: flash_count} =
      Enum.reduce(1..@steps_to_run, %{energy_levels: energy_levels, flash_count: 0}, fn _, acc -> run_step(acc) end)

    flash_count
  end

  def run_step(%{energy_levels: energy_levels, flash_count: flash_count}) do
    {updated_energy_levels, new_flash_count} =
      energy_levels
      |> increment_energy_levels()
      |> propagate_flashes()

    %{energy_levels: updated_energy_levels, flash_count: flash_count + new_flash_count}
  end

  def increment_energy_levels(energy_levels) do
    energy_levels
    |> Enum.map(fn {key, %{energy_level: energy_level}} -> {key, %{energy_level: energy_level + 1, flashed?: false}} end)
    |> Enum.into(%{})
  end

  def propagate_flashes(energy_levels, _flashes \\ [], flash_count \\ 0) do
    case find_new_flashes(energy_levels) do
      {updated_energy_levels, []} -> {updated_energy_levels, flash_count}
      {updated_energy_levels, new_flashes} -> propagate_flashes(updated_energy_levels, new_flashes, flash_count + length(new_flashes))
    end
  end

  def find_new_flashes(energy_levels) do
    new_flashes =
      Enum.filter(energy_levels, fn {_, %{energy_level: energy_level, flashed?: flashed?}} -> energy_level > @flash_threshold && not(flashed?) end)

    updated_energy_levels =
      Enum.reduce(new_flashes, update_flashes(new_flashes, energy_levels), &increment_surrounding_energy_levels(&2, &1))

    {updated_energy_levels, new_flashes}
  end

  def update_flashes(flashes, energy_levels) do
    Enum.reduce(flashes, energy_levels, fn {key, _}, energy_levels_acc ->
      Map.put(energy_levels_acc, key, %{energy_level: 0, flashed?: true})
    end)
  end

  def increment_surrounding_energy_levels(energy_levels, {{x, y}, _}) do
      [
        {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1},
        {x - 1, y}, {x, y}, {x + 1, y},
        {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}
      ]
      |> Enum.reject(&is_nil(Map.get(energy_levels, &1)))
      |> Enum.reject(fn key -> Map.get(energy_levels, key).flashed? end)
      |> Enum.reduce(energy_levels, fn key, energy_levels_acc ->
        Map.update!(energy_levels_acc, key, fn %{energy_level: energy_level} = val -> %{val | energy_level: energy_level + 1} end)
      end)
  end
end

IO.inspect(DumboOctopus.run())
