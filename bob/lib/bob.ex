defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    word = String.trim(input)

    cond do
      shout_question?(word) -> "Calm down, I know what I'm doing!"
      shout?(word) -> "Whoa, chill out!"
      question?(word) -> "Sure."
      silent?(word) -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  ## Privates

  defp shout?(word) do
    String.match?(word, ~r/(?:[[:upper:]]{4}|!(?<=[[:upper:]]{1}!))/u)
  end

  defp question?(word) do
    String.match?(word, ~r/\?$/)
  end

  defp shout_question?(word) do
    shout?(word) && question?(word)
  end

  defp silent?(word) do
    String.match?(word, ~r/^\s*$/)
  end
end
