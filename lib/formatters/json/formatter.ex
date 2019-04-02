defmodule Chapters.Formatters.Json.Formatter do
  @spec format([Chapters.Chapter.t()]) :: binary()
  def format(input) do
    input
    |> Enum.map(fn chapter ->
      %{
        start: Map.get(chapter, :time) |> Chapters.Formatters.Normalplaytime.Formatter.format(),
        title: Map.get(chapter, :title)
      }
      |> maybe_put(:href, Map.get(chapter, :url))
      |> maybe_put(:image, Map.get(chapter, :image))
    end)
    |> Jason.encode!()
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
