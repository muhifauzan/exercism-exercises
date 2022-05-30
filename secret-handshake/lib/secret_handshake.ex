defmodule SecretHandshake do
  use Bitwise, only_operators: true

  @secret_codes %{
    0b1 => "wink",
    0b10 => "double blink",
    0b100 => "close your eyes",
    0b1000 => "jump"
  }

  @codes @secret_codes
         |> Map.keys()
         |> Enum.reverse()

  @inverse_code 0b10000

  @max_code Enum.sum([@inverse_code | @codes])

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    @codes
    |> Enum.reduce_while({0, code, []}, fn code, {_and_bits, secret, actions} ->
      codes_reducer(code, {secret &&& code, secret, actions})
    end)
    |> build_actions()
  end

  ## Privates

  defp codes_reducer(_code, {_and_bits, secret, _actions} = acc)
       when secret > @max_code do
    {:halt, acc}
  end

  defp codes_reducer(_, {0, _, _} = acc) do
    {:cont, acc}
  end

  defp codes_reducer(code, {and_bits, secret, actions}) do
    {:cont, {and_bits, secret, [@secret_codes[code] | actions]}}
  end

  defp build_actions({_and_bits, secret, actions}) do
    if (secret &&& @inverse_code) == @inverse_code do
      Enum.reverse(actions)
    else
      actions
    end
  end
end
