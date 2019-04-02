defmodule Chapters do
  alias Chapters.Parsers

  @type chapter_format() :: :psc | :mp4chaps | :json

  @doc """
  Decode podcast chapter binary.

  Supported formats: :psc, :mp4chaps, :json
  """
  @spec decode(binary(), chapter_format()) :: [Chapters.Chapter.t()]
  def decode(input, type)

  def decode(input, :psc) when is_binary(input) do
    Parsers.PSC.Parser.parse(input)
  end

  def decode(input, :mp4chaps) when is_binary(input) do
    Parsers.Mp4chaps.Parser.parse(input)
  end

  def decode(input, :json) when is_binary(input) do
    Parsers.Json.Parser.parse(input)
  end

  @doc """
  Encode podcast chapter object into binary.

  Supported formats: :psc, :mp4chaps, :json
  """
  @spec encode([Chapters.Chapter.t()], chapter_format()) :: binary()
  def encode(input, type)

  def encode(input, :json) do
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
