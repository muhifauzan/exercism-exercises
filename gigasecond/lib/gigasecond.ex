defmodule Gigasecond do
  @type date :: {pos_integer, pos_integer, pos_integer}
  @type time :: {pos_integer, pos_integer, pos_integer}

  @seconds 1_000_000_000
  @minutes div(@seconds, 60)
  @hours div(@minutes, 60)
  @days div(@hours, 24)
  @gigaseconds {{rem(@hours, 24), rem(@minutes, 60), rem(@seconds, 60)}, @days}
  @year_days 365
  @year_months [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  @leap_year_days 366
  @leap_year_months [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({date, time}) :: {date, time}
  def from({{_year, _month, _date} = date, {_hour, _minute, _second} = time}) do
    {{_hours, _minutes, _seconds} = times, days} = @gigaseconds
    {time, adays} = advance_time(time, times)
    date = advance_date(date, days + adays)
    {date, time}
  end

  # Privates

  defp advance_time({hour, minute, second}, {hours, minutes, seconds}) do
    {second, aminutes} = offset(second + seconds, 60)
    {minute, ahours} = offset(minute + minutes + aminutes, 60)
    {hour, days} = offset(hour + hours + ahours, 24)
    {{hour, minute, second}, days}
  end

  defp offset(dividend, divisor) do
    {rem(dividend, divisor), div(dividend, divisor)}
  end

  defp advance_date({year, month, day}, days) do
    days = days + day + calculate_days(year, month)
    {year, days} = advance_year(year, days)
    {month, day} = advance_month(year, days)
    {year, month, day}
  end

  defp calculate_days(year, month) do
    year
    |> get_year_months()
    |> Enum.take(month - 1)
    |> Enum.sum()
  end

  defp advance_year(year, days) when days >= @year_days do
    year_days =
      if leap_year?(year) do
        @leap_year_days
      else
        @year_days
      end

    advance_year(year + 1, days - year_days)
  end

  defp advance_year(year, days) do
    {year, days}
  end

  defp advance_month(year, days) do
    year
    |> get_year_months()
    |> Enum.reduce_while({1, days}, &months_reducer/2)
  end

  defp months_reducer(cdays, {month, days}) when days <= cdays do
    {:halt, {month, days}}
  end

  defp months_reducer(cdays, {month, days}) do
    {:cont, {month + 1, days - cdays}}
  end

  defp get_year_months(year) do
    if leap_year?(year) do
      @leap_year_months
    else
      @year_months
    end
  end

  defp leap_year?(year) do
    rem(year, 4) == 0
  end
end
