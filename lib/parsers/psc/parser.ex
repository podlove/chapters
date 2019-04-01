defmodule Chapters.Parsers.PSC.Parser do
  import SweetXml
  alias Chapters.Chapter
  alias Chapters.Parsers.Normalplaytime.Parser, as: NPT

  def parse(input) do
    input
    |> xmap(
      chapters: [
        ~x"//psc:chapter"l,
        title: ~x"./@title"s,
        time: ~x"./@start"s,
        url: ~x"./@href"s
      ]
    )
    |> Map.get(:chapters)
    |> Enum.map(fn %{title: title, time: time, url: url} ->
      {:ok, ms} = parse_time(time)

      url =
        if url == "" do
          nil
        else
          url
        end

      %Chapter{title: title, time: ms, url: url}
    end)
  end

  defp parse_time(time) when is_binary(time) do
    {:ok, result, _, _, _, _} = NPT.parse(time)
    {:ok, NPT.total_ms(result)}
  end
end
