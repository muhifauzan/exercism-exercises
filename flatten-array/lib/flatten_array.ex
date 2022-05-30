defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    do_flatten(list, {[], []})
  end

  ## Privates

  defp do_flatten([], {[], acc}) do
    Enum.reverse(acc)
  end

  defp do_flatten([head | tail], {[], acc}) do
    do_flatten(tail, {head, acc})
  end

  defp do_flatten(list, {[head | []], acc}) do
    do_flatten(list, {head, acc})
  end

  defp do_flatten(list, {[head | tail], acc}) do
    do_flatten([tail | list], {head, acc})
  end

  defp do_flatten(list, {nil, acc}) do
    do_flatten(list, {[], acc})
  end

  defp do_flatten(list, {item, acc}) do
    do_flatten(list, {[], [item | acc]})
  end
end
