defmodule Chapters.Parsers.Json.Parser do
  alias Chapters.Chapter
  alias Chapters.Parsers.Normalplaytime.Parser, as: NPT

  def parse(input) do
    {:ok, chapters} = Jason.decode(input)

    chapters
    |> Enum.map(fn chapter ->
      %Chapter{
        title: chapter["title"],
        time: parse_time(chapter["start"]),
        url: chapter["href"],
        image: chapter["image"]
      }
    end)
  end

  defp parse_time(time) when is_binary(time) do
    NPT.parse_total_ms(time)
  end
end
