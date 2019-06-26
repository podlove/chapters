defmodule NormalplaytimeTest do
  use ExUnit.Case
  doctest Chapters.Parsers.Normalplaytime.Parser, import: true

  doctest Chapters.Formatters.Normalplaytime.Formatter, import: true
end
