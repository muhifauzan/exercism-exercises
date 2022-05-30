defmodule Raindrops do
  @prime_sounds %{
    3 => "Pling",
    5 => "Plang",
    7 => "Plong"
  }

  @primes Map.keys(@prime_sounds)

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
  just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    Enum.reduce_while(@primes, {nil, number, ""}, fn prime, {_remainder, number, sounds} ->
      primes_reducer(prime, {rem(number, prime), number, sounds})
    end)
    |> build_sounds()
  end

  ## Privates

  defp primes_reducer(prime, {_remainder, number, _sounds} = acc)
       when number < prime do
    {:halt, acc}
  end

  defp primes_reducer(prime, {0, number, sounds}) do
    {:cont, {nil, number, sounds <> @prime_sounds[prime]}}
  end

  defp primes_reducer(_, acc) do
    {:cont, acc}
  end

  defp build_sounds({_remainder, number, ""}) do
    "#{number}"
  end

  defp build_sounds({_, _, sounds}) do
    sounds
  end
end
