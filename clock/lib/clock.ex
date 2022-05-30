defmodule Clock do
  defstruct hour: 0, minute: 0

  @type t :: %__MODULE__{
          hour: pos_integer,
          minute: pos_integer
        }

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock.t()
  def new(hour, minute) do
    build_time(hour, minute)
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock.t(), integer) :: Clock.t()
  def add(%Clock{hour: hour, minute: minute}, minutes) do
    build_time(hour, minute + minutes)
  end

  # Privates

  defp build_time(hour, minute) do
    {minute, hours} = offset_minute(minute)
    hour = normalize(hour + hours, 24)
    %__MODULE__{hour: hour, minute: minute}
  end

  defp offset_minute(-60) do
    {0, -1}
  end

  defp offset_minute(minute) when minute < 0 do
    {normalize(minute, 60), div(minute, 60) - 1}
  end

  defp offset_minute(minute) do
    {normalize(minute, 60), div(minute, 60)}
  end

  defp normalize(unit, limit) do
    rem(limit + rem(unit, limit), limit)
  end
end

defimpl String.Chars, for: Clock do
  def to_string(%Clock{hour: hour, minute: minute}) do
    "#{pad_leading_zero(hour)}:#{pad_leading_zero(minute)}"
  end

  # Privates

  defp pad_leading_zero(number) do
    String.pad_leading("#{number}", 2, "0")
  end
end
