defmodule Chapters.Formatters.PSC.Formatter do
  import XmlBuilder

  alias Chapters.Chapter

  @spec format([Chapter.t()]) :: binary()
  def format(input) do
    chapters =
      Enum.map(input, fn chapter ->
        element(
          :"psc:chapter",
          Chapter.to_keylist(chapter),
          nil
        )
      end)

    document(
      :"psc:chapters",
      %{version: 1.2, "xmlns:psc": "http://podlove.org/simple-chapters"},
      chapters
    )
    |> generate
  end
end
