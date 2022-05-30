defmodule RomanNumerals do
  @roman_numerals %{
    1 => "I",
    4 => "IV",
    5 => "V",
    9 => "IX",
    10 => "X",
    40 => "XL",
    50 => "L",
    90 => "XC",
    100 => "C",
    400 => "CD",
    500 => "D",
    900 => "CM",
    1000 => "M"
  }

  @numbers @roman_numerals
           |> Map.keys()
           |> Enum.reverse()

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    build_numeral(number, @numbers, "")
  end

  ## Privates

  defp build_numeral(0, _numbers, acc) do
    acc
  end

  defp build_numeral(number, [head | _tail] = numbers, acc) when number >= head do
    build_numeral(number - head, numbers, acc <> @roman_numerals[head])
  end

  defp build_numeral(number, [_head | tail], acc) do
    build_numeral(number, tail, acc)
  end
end
