defmodule Chapters.Formatters.PSC.Formatter do
  import XmlBuilder

  @spec format([Chapters.Chapter.t()]) :: binary()
  def format(input) do
    chapters =
      Enum.map(input, fn chapter ->
        element(
          :"psc:chapter",
          %{
            start:
              Map.get(chapter, :time) |> Chapters.Formatters.Normalplaytime.Formatter.format(),
            title: Map.get(chapter, :title)
          }
          |> maybe_put(:href, Map.get(chapter, :url))
          |> maybe_put(:image, Map.get(chapter, :image))
        )
      end)

    document(
      :"psc:chapters",
      %{version: 1.2, "xmlns:psc": "http://podlove.org/simple-chapters"},
      chapters
    )
    |> generate
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
