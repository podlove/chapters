defmodule Chapters.Parsers.Json.Parser do
  alias Chapters.Chapter
  alias Chapters.Parsers.Normalplaytime.Parser, as: NPT

  def parse(input) do
    {:ok, chapters} = Jason.decode(input)

    chapters
    |> Enum.map(fn chapter ->
      {:ok, time} = Map.get(chapter, "start") |> parse_time

      %Chapter{
        title: Map.get(chapter, "title"),
        time: time,
        url: Map.get(chapter, "href")
      }
    end)
  end

  defp parse_time(time) when is_binary(time) do
    {:ok, result, _, _, _, _} = NPT.parse(time)
    {:ok, NPT.total_ms(result)}
  end
end
