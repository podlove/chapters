defmodule ChaptersTest do
  use ExUnit.Case

  alias Chapters.Chapter

  @psc_chapters ~S"""
  <psc:chapters version="1.2" xmlns:psc="http://podlove.org/simple-chapters">
      <psc:chapter start="00:00:00" title="Intro" />
      <psc:chapter start="00:01:59" title="Podlove" href="http://podlove.org/" />
  </psc:chapters>
  """

  test "decode PSC" do
    assert Chapters.decode(@psc_chapters, :psc) == [
             %Chapter{time: 0, title: "Intro"},
             %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
           ]
  end

  @mp4chaps_chapters ~S"""
  00:00:00 Intro
  00:01:59 Podlove <http://podlove.org/>
  """
  test "decode mp4chaps" do
    assert Chapters.decode(@mp4chaps_chapters, :mp4chaps) == [
             %Chapter{time: 0, title: "Intro"},
             %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
           ]
  end

  @json_chapters ~S"""
  [
  	{ "start": "00:00:00.000", "title": "Intro"},
  	{ "start": "00:01:59.000", "title": "Podlove", "href": "http://podlove.org/"}
  ]
  """

  test "decode json" do
    assert Chapters.decode(@json_chapters, :json) == [
             %Chapter{time: 0, title: "Intro"},
             %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
           ]
  end

  test "encode json" do
    assert Chapters.encode(
             [
               %Chapter{time: 0, title: "Intro"},
               %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
             ],
             :json
           )
           |> Jason.decode!() == Jason.decode!(@json_chapters)
  end

  @psc_chapters ~S"""
  <?xml version="1.0" encoding="UTF-8"?>
  <psc:chapters version="1.2" xmlns:psc="http://podlove.org/simple-chapters">
    <psc:chapter start="00:00:00.000" title="Intro"/>
    <psc:chapter href="http://podlove.org/" start="00:01:59.000" title="Podlove"/>
  </psc:chapters>
  """

  test "encode psc" do
    assert Chapters.encode(
             [
               %Chapter{time: 0, title: "Intro"},
               %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
             ],
             :psc
           )
           |> String.trim() == String.trim(@psc_chapters)
  end

  @mp4chaps_chapters ~S"""
  00:00:00.000 Intro
  00:01:59.000 Podlove <http://podlove.org/>
  """
  test "encode mp4chaps" do
    assert Chapters.encode(
             [
               %Chapter{time: 0, title: "Intro"},
               %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
             ],
             :mp4chaps
           )
           |> String.trim() ==
             String.trim(@mp4chaps_chapters)
  end
end
