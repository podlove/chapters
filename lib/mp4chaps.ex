defmodule Chapters.Mp4chaps do
  import NimbleParsec

  @moduledoc ~S"""
  Mp4chaps parser.

  ## Examples

    iex> {:ok, [r | _], "", _, _, _} = parse("00:00:00 Intro")
    iex> r
    [time: [hours: 0, minutes: 0, seconds: 0], title: "Intro"]

    iex> {:ok, r, "", _, _, _} = parse("00:00:00 Intro\r\n00:01:02 Podlove <https://podlove.org>")
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
    :parse,
    repeat(line |> wrap())
  )
end
