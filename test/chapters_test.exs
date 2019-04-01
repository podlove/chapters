defmodule ChaptersTest do
  use ExUnit.Case
  doctest Chapters

  alias Chapters.Chapter

  @psc_chapters ~S"""
  <psc:chapters version="1.2" xmlns:psc="http://podlove.org/simple-chapters">
      <psc:chapter start="00:00:00" title="Intro" />
      <psc:chapter start="00:01:59" title="Podlove" href="http://podlove.org/" />
  </psc:chapters>
  """

  test "decode PSC" do
    assert Chapters.decode(:psc, @psc_chapters) == [
             %Chapter{time: 0, title: "Intro"},
             %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
           ]
  end

  @mp4chaps_chapters ~S"""
  00:00:00 Intro
  00:01:59 Podlove <http://podlove.org/>
  """
  test "decode mp4chaps" do
    assert Chapters.decode(:mp4chaps, @mp4chaps_chapters) == [
             %Chapter{time: 0, title: "Intro"},
             %Chapter{time: 119_000, title: "Podlove", url: "http://podlove.org/"}
           ]
  end
end
