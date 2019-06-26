defmodule Chapters.Formatters.PSC.Formatter do
  import XmlBuilder

  @spec format([Chapters.Chapter.t()]) :: binary()
  def format(input) do
    chapters =
      Enum.map(input, fn chapter ->
        element(
          :"psc:chapter",
          [
            start:
              chapter.time
              |> Chapters.Formatters.Normalplaytime.Formatter.format(),
            title: chapter.title
          ]
          |> maybe_put(:href, chapter.url)
          |> maybe_put(:image, chapter.image),
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

  defp maybe_put(keylist, _key, nil), do: keylist
  defp maybe_put(keylist, key, value), do: List.keystore(keylist, key, 0, {key, value})
end
