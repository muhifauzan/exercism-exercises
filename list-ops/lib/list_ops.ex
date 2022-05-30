defmodule ListOps do
  @type acc :: any

  @spec count(list) :: non_neg_integer
  def count(list) do
    foldl(list, 0, fn _, acc -> acc + 1 end)
  end

  @spec reverse(list) :: list
  def reverse(list) do
    foldl(list, [], &[&1 | &2])
  end

  @spec map(list, (any -> any)) :: list
  def map(list, fun) do
    list
    |> foldl([], &[fun.(&1) | &2])
    |> reverse()
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(list, fun) do
    list
    |> foldl([], fn item, acc ->
      if fun.(item) do
        [item | acc]
      else
        acc
      end
    end)
    |> reverse()
  end

  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _fun) do
    acc
  end

  def foldl([head | tail], acc, fun) do
    foldl(tail, fun.(head, acc), fun)
  end

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(list, acc, fun) do
    list
    |> reverse()
    |> foldl(acc, fun)
  end

  @spec append(list, list) :: list
  def append(left, right) do
    left
    |> reverse()
    |> foldl(right, &[&1 | &2])
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    foldl(ll, [], &append(&2, &1))
  end
end
