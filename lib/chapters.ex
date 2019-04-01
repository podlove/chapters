defmodule Chapters do
  alias Chapters.Chapter
  alias Chapters.Mp4chaps
  alias Chapters.Time.Normalplaytime, as: NPT

  def decode(:psc, xml) when is_binary(xml) do
    import SweetXml

    xml
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

  def decode(:mp4chaps, input) when is_binary(input) do
    {:ok, chapters, _, _, _, _} = Mp4chaps.parse(input)

    chapters
    |> Enum.map(fn chapter ->
      %Chapter{
        title: Keyword.get(chapter, :title),
        time: Keyword.get(chapter, :time) |> NPT.total_ms(),
        url: Keyword.get(chapter, :url)
      }
    end)
  end

  def decode(:json, input) when is_binary(input) do
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
