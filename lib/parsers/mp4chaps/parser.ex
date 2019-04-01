defmodule Chapters.Parsers.Mp4chaps.Parser do
  import NimbleParsec
  alias Chapters.Chapter
  alias Chapters.Parsers.Normalplaytime.Parser, as: NPT

  @moduledoc ~S"""
  Mp4chaps parser.

  ## Examples

    iex> {:ok, [r | _], "", _, _, _} = mp4chaps("00:00:00 Intro")
    iex> r
    [time: [hours: 0, minutes: 0, seconds: 0], title: "Intro"]

    iex> {:ok, r, "", _, _, _} = mp4chaps("00:00:00 Intro\r\n00:01:02 Podlove <https://podlove.org>")
    iex> r
    [
      [time: [hours: 0, minutes: 0, seconds: 0], title: "Intro"],
      [time: [hours: 0, minutes: 1, seconds: 2], title: "Podlove", url: "https://podlove.org"]
    ]
  """

  alias Chapters.Parsers.Helpers

  url =
    ignore(ascii_char([?<]))
    |> repeat(
      lookahead_not(ascii_char([?>]))
      |> concat(utf8_char([]))
    )
    |> ignore(ascii_char([?>]))
    |> reduce({List, :to_string, []})
    |> map({String, :trim, []})

  end_of_line =
    choice([
      eos(),
      ascii_string([?\r, ?\n], min: 1, max: 2)
    ])

  title =
    utf8_char([])
    |> repeat(lookahead_not(choice([ascii_char([?<]), end_of_line])) |> concat(utf8_char([])))
    |> reduce({List, :to_string, []})
    |> map({String, :trim, []})

  line =
    Helpers.normalplaytime()
    |> tag(:time)
    |> ignore(string(" "))
    |> concat(title |> unwrap_and_tag(:title))
    |> optional(url |> unwrap_and_tag(:url))
    |> ignore(end_of_line)

  defparsec(
    :mp4chaps,
    repeat(line |> wrap())
  )

  def parse(input) do
    {:ok, chapters, _, _, _, _} = mp4chaps(input)

    chapters
    |> Enum.map(fn chapter ->
      %Chapter{
        title: Keyword.get(chapter, :title),
        time: Keyword.get(chapter, :time) |> NPT.total_ms(),
        url: Keyword.get(chapter, :url)
      }
    end)
  end
end
