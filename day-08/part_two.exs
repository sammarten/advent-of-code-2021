defmodule SevenSegmentSearch do
  def run(input_path \\ "input.txt") do
    input_path
    |> read_input()
    |> analyze_displays()
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
      input: to_ordered_list(input) ,
      output: to_ordered_list(output)
    }
  end

  def to_ordered_list(data) do
    data
    |> String.split(" ", trim: true)
    |> Enum.map(fn line -> line |> String.graphemes() |> Enum.sort() end)
  end

  def analyze_displays(displays) do
    displays
    |> Enum.map(&decipher_digits/1)
    |> Enum.sum()
  end

  def decipher_digits(%{input: input, output: output}) do
    input
    |> find_digit_segments()
    |> build_output_number(output)
  end

  def find_digit_segments(input) do
    [input, %{}]
    |> find_one()
    |> find_four()
    |> find_seven()
    |> find_eight()
    |> find_nine()
    |> find_six()
    |> find_zero()
    |> find_three()
    |> find_five()
    |> find_two()
    |> Enum.at(1)
  end

  def find_one([input, acc]) do
    [val] = one = Enum.filter(input, &(Enum.count(&1) == 2))
    [input -- one, Map.put(acc, 1, Enum.sort(val))]
  end

  def find_four([input, acc]) do
    [val] = four = Enum.filter(input, &(Enum.count(&1) == 4))
    [input -- four, Map.put(acc, 4, Enum.sort(val))]
  end

  def find_seven([input, acc]) do
    [val] = seven = Enum.filter(input, &(Enum.count(&1) == 3))
    [input -- seven, Map.put(acc, 7, Enum.sort(val))]
  end

  def find_eight([input, acc]) do
    [val] = eight = Enum.filter(input, &(Enum.count(&1) == 7))
    [input -- eight, Map.put(acc, 8, Enum.sort(val))]
  end

  def find_nine([input, %{7 => seven_segments, 4 => four_segments} = acc]) do
    [val] = 
      nine = 
      Enum.filter(input, 
        &((Enum.count(&1) == 6) && (seven_segments -- &1 == []) && (four_segments -- &1 == [])))
    [input -- nine, Map.put(acc, 9, Enum.sort(val))]    
  end

  def find_six([input, %{1 => one_segments} = acc]) do
    [val] = 
      six = 
      Enum.filter(input, 
        &((Enum.count(&1) == 6) && (length(one_segments -- &1) == 1)))
    [input -- six, Map.put(acc, 6, Enum.sort(val))]    
  end

  def find_zero([input, %{4 => four_segments} = acc]) do
    [val] = 
      zero = 
      Enum.filter(input, 
        &((Enum.count(&1) == 6) && (length(four_segments -- &1) == 1)))
    [input -- zero, Map.put(acc, 0, Enum.sort(val))]    
  end

  def find_three([input, %{1 => one_segments} = acc]) do
    [val] = 
      three = 
      Enum.filter(input, 
        &((Enum.count(&1) == 5) && (one_segments -- &1 == [])))
    [input -- three, Map.put(acc, 3, Enum.sort(val))]    
  end

  def find_five([input, %{6 => six_segments} = acc]) do
    [val] = 
      five = 
      Enum.filter(input, 
        &((Enum.count(&1) == 5) && (&1 -- six_segments == [])))
    [input -- five, Map.put(acc, 5, Enum.sort(val))]    
  end

  def find_two([input, %{6 => six_segments} = acc]) do
    [val] = 
      two = 
      Enum.filter(input, 
        &((Enum.count(&1) == 5) && (length(&1 -- six_segments) == 1)))
    [input -- two, Map.put(acc, 2, Enum.sort(val))]    
  end

  def build_output_number(digits, output) do
    output
    |> Enum.map(&match_digit(digits, &1))
    |> Enum.join()
    |> String.to_integer()
  end

  def match_digit(digits, digit) do
    cond do
      digits[0] == digit -> 0
      digits[1] == digit -> 1
      digits[2] == digit -> 2
      digits[3] == digit -> 3
      digits[4] == digit -> 4
      digits[5] == digit -> 5
      digits[6] == digit -> 6
      digits[7] == digit -> 7
      digits[8] == digit -> 8
      digits[9] == digit -> 9
    end
  end
end

IO.inspect(SevenSegmentSearch.run())

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg
