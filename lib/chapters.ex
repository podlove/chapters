defmodule Chapters do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

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
    Chapters.Formatters.Json.Formatter.format(input)
  end

  def encode(input, :psc) do
    Chapters.Formatters.PSC.Formatter.format(input)
  end

  def encode(input, :mp4chaps) do
    Chapters.Formatters.Mp4chaps.Formatter.format(input)
  end
end
