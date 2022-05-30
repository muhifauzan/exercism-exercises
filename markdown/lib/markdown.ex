defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map_join(&process/1)
    |> patch_list_tag()
  end

  # Privates

  defp process("#" <> _ = line) do
    parse_header(line, 0)
  end

  defp process("*" <> line) do
    parse_list(line)
  end

  defp process(line) do
    parse_paragraph(line)
  end

  defp parse_header("#######" <> _ = line, _level) do
    parse_paragraph(line)
  end

  defp parse_header("#" <> line, level) do
    parse_header(line, level + 1)
  end

  defp parse_header(line, level) do
    tag("h#{level}", line)
  end

  defp parse_list(line) do
    tag("li", line)
  end

  defp parse_paragraph(line) do
    tag("p", line)
  end

  defp tag(tag, line) do
    line =
      line
      |> String.trim()
      |> parse_inline_tag()

    "<#{tag}>#{line}</#{tag}>"
  end

  defp parse_inline_tag(line) do
    line
    |> String.replace(~r/__(.+)__/, "<strong>\\1</strong>")
    |> String.replace(~r/_(.+)_/, "<em>\\1</em>")
  end

  defp patch_list_tag(line) do
    String.replace(line, ~r/(<li>.*<\/li>)/, "<ul>\\1</ul>", global: false)
  end
end
