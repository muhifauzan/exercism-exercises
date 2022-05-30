defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    coins
    |> Enum.reverse()
    |> build_changes(target, [], {[], []})
  end

  ## Privates

  # This implement memoisation in a form of {options, rchange} where options is
  # partial permutation of iterated coin tails so far and rchange is the current
  # minimal possible change. This also implement optimisation where current
  # iteration will be discarded if the coins is not empty yet and the current
  # change so far is greater than or equal to rchange.
  defp build_changes([] = _coins, _remainder, _change, {[] = _options, [] = _rchange}) do
    {:error, "cannot change"}
  end

  defp build_changes(_, 0, change, {[], _}) do
    {:ok, change}
  end

  defp build_changes([], _, _, {[], rchange}) do
    {:ok, rchange}
  end

  defp build_changes(_, 0, change, {[{coins, remainder, xchange} | options], _}) do
    build_changes(coins, remainder, xchange, {options, change})
  end

  defp build_changes([], _, _, {[{coins, remainder, xchange} | options], rchange}) do
    build_changes(coins, remainder, xchange, {options, rchange})
  end

  defp build_changes([coin | tail], remainder, change, acc) when remainder < coin do
    build_changes(tail, remainder, change, acc)
  end

  defp build_changes([coin | tail] = coins, remainder, change, {options, []}) do
    build_changes(
      coins,
      remainder - coin,
      [coin | change],
      {[{tail, remainder, change} | options], []}
    )
  end

  defp build_changes(_, _, change, {[{coins, remainder, xchange} | options], rchange})
       when length(change) >= length(rchange) do
    build_changes(coins, remainder, xchange, {options, rchange})
  end

  defp build_changes([coin | tail] = coins, remainder, change, {options, rchange}) do
    build_changes(
      coins,
      remainder - coin,
      [coin | change],
      {[{tail, remainder, change} | options], rchange}
    )
  end
end
