defmodule Chapters.Parsers.PSC.Parser do
  import SweetXml
  alias Chapters.Chapter
  alias Chapters.Parsers.Normalplaytime.Parser, as: NPT

  def parse(input) do
    input
    |> xmap(
      chapters: [
        ~x"//psc:chapter"l,
        start: ~x"./@start"s,
        title: ~x"./@title"s,
        href: ~x"./@href"s,
        image: ~x"./@image"s
      ]
    )
    |> Map.get(:chapters)
    |> Enum.map(fn parse_map ->
      Enum.reduce(parse_map, %Chapter{}, fn
        {:start, timestring}, chapter ->
          %Chapter{chapter | start: parse_time(timestring)}

        {:title, title}, chapter when is_binary(title) ->
          %Chapter{chapter | title: title}

        {:href, value}, chapter when is_binary(value) and byte_size(value) > 0 ->
          %Chapter{chapter | href: value}

        {:image, value}, chapter when is_binary(value) and byte_size(value) > 0 ->
          %Chapter{chapter | image: value}

        _, chapter ->
          chapter
      end)
    end)
  end

  defp parse_time(time) when is_binary(time) do
    NPT.parse_total_ms(time)
  end
end
