defmodule Chapters.Parsers.Helpers do
  import NimbleParsec

  def hours do
    integer(min: 1)
    |> unwrap_and_tag(:hours)
  end

  def minutes do
    integer(min: 1, max: 2)
    |> unwrap_and_tag(:minutes)
  end

  def seconds do
    integer(min: 1, max: 2)
    |> unwrap_and_tag(:seconds)
  end

  def milliseconds do
    ascii_string([?0..?9], min: 1, max: 3)
    |> map({Chapters.Parsers.Normalplaytime.Parser, :convert_ms, []})
    |> unwrap_and_tag(:milliseconds)
  end

  def component_ms do
    ignore(string("."))
    |> concat(milliseconds())
  end

  def time_s do
    seconds()
    |> optional(component_ms())
  end

  def time_ms do
    minutes()
    |> ignore(string(":"))
    |> concat(time_s())
  end

  def time_hms do
    hours()
    |> ignore(string(":"))
    |> concat(time_ms())
  end

  def normalplaytime() do
    choice([time_hms(), time_ms(), time_s()])
  end
end
