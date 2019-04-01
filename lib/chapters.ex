defmodule Chapters do
  alias Chapters.Parsers

  @doc """
  Decode podcast chapter binary.

  Supported formats: :psc, :mp4chaps, :json
  """
  @spec decode(atom(), binary()) :: [Chapters.Chapter.t()]
  def decode(type, input)

  def decode(:psc, input) when is_binary(input) do
    Parsers.PSC.Parser.parse(input)
  end

  def decode(:mp4chaps, input) when is_binary(input) do
    Parsers.Mp4chaps.Parser.parse(input)
  end

  def decode(:json, input) when is_binary(input) do
    Parsers.Json.Parser.parse(input)
  end
end
