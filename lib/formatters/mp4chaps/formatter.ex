defmodule Chapters.Formatters.Mp4chaps.Formatter do
  @spec format([Chapters.Chapter.t()]) :: binary()
  def format(input) do
    input
    |> Enum.map(fn chapter ->
      time = Map.get(chapter, :time) |> Chapters.Formatters.Normalplaytime.Formatter.format()
      title = Map.get(chapter, :title)

      "#{time} #{title}" |> maybe_put_url(Map.get(chapter, :url))
    end)
    |> Enum.join("\n")
  end

  defp maybe_put_url(binary, nil), do: binary
  defp maybe_put_url(binary, url), do: binary <> " <#{url}>"
end
