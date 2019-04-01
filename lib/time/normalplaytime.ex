defmodule Chapters.Time.Normalplaytime do
  import NimbleParsec

  @moduledoc ~S"""
  Parses Normal Play Time strings.

  See https://www.w3.org/TR/media-frags/#npttimedef.

  ## Examples

    iex> {:ok, r, "", _, _, _} = parse("1")
    iex> r
    [{:seconds, 1}]

    iex> {:ok, r, "", _, _, _} = parse("1.843")
    iex> r
    [{:seconds, 1}, {:milliseconds, 843}]

    iex> {:ok, r, "", _, _, _} = parse("12:34")
    iex> r
    [{:minutes, 12}, {:seconds, 34}]

    iex> {:ok, r, "", _, _, _} = parse("12:34.56")
    iex> r
    [{:minutes, 12}, {:seconds, 34}, {:milliseconds, 560}]

    iex> {:ok, r, "", _, _, _} = parse("12:34.5")
    iex> r
    [{:minutes, 12}, {:seconds, 34}, {:milliseconds, 500}]

    iex> {:ok, r, "", _, _, _} = parse("1:2")
    iex> r
    [{:minutes, 1}, {:seconds, 2}]

    iex> {:ok, r, "", _, _, _} = parse("1:2:3.4")
    iex> r
    [{:hours, 1}, {:minutes, 2}, {:seconds, 3}, {:milliseconds, 400}]

    iex> {:ok, r, "", _, _, _} = parse("01:02:03")
    iex> r
    [{:hours, 1}, {:minutes, 2}, {:seconds, 3}]

    iex> {:ok, r, "", _, _, _} = parse("00:00:00.123")
    iex> r
    [{:hours, 0}, {:minutes, 0}, {:seconds, 0}, {:milliseconds, 123}]

  """

  @doc """
  Get total milliseconds from parse result.

  ## Examples

    iex> total_ms [{:hours, 1}, {:minutes, 2}, {:seconds, 3}, {:milliseconds, 400}]
    3723400

  """
  def total_ms(parse_result) do
    parse_result
    |> Enum.reduce(0, fn
      {:hours, hours}, ms -> ms + :timer.hours(hours)
      {:minutes, minutes}, ms -> ms + :timer.minutes(minutes)
      {:seconds, seconds}, ms -> ms + :timer.seconds(seconds)
      {:milliseconds, milliseconds}, ms -> ms + milliseconds
    end)
  end

  defparsec(:parse, Chapters.Parsers.Helpers.normalplaytime())

  def convert_ms(n) when is_binary(n) and byte_size(n) == 1 do
    String.to_integer(n) * 100
  end

  def convert_ms(n) when is_binary(n) and byte_size(n) == 2 do
    String.to_integer(n) * 10
  end

  def convert_ms(n) when is_binary(n) and byte_size(n) == 3 do
    String.to_integer(n)
  end
end
