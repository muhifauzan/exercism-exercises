defmodule BankAccount do
  defstruct balance: 0

  @type t :: %__MODULE__{
          balance: non_neg_integer
        }

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = Agent.start_link(fn -> %__MODULE__{} end)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    safe_process(account, fn ->
      Agent.get(account, & &1.balance)
    end)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    safe_process(account, fn ->
      Agent.update(account, Map, :update, [:balance, 0, &(&1 + amount)])
    end)
  end

  # Privates

  defp safe_process(account, fun) do
    case Process.alive?(account) do
      true -> fun.()
      false -> {:error, :account_closed}
    end
  end
end
