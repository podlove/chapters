defmodule ChaptersTest do
  use ExUnit.Case

  alias Chapters.Chapter

  @psc_chapters ~S"""
  <psc:chapters version="1.2" xmlns:psc="http://podlove.org/simple-chapters">
      <psc:chapter start="00:00:00" title="Intro" />
      <psc:chapter start="00:01:59" title="Podlove" href="http://podlove.org/" />
      <psc:chapter start="09:59" title="Podlove Logo" image="http://podlove.org/logo.jpg" />
      <psc:chapter start="00:41:51.792" title="Erratum: Wir meinen Steve Jackson" href='https://en.wikipedia.org/wiki/Steve_Jackson_(American_game_designer)#The_two_"Steve_Jacksons"' image="http://fanboys.fm/assets/123/Chapter07.jpeg"/>
  </psc:chapters>
  """

  test "decode PSC" do
    assert Chapters.decode(@psc_chapters, :psc) == [
             %Chapter{start: 0, title: "Intro"},
             %Chapter{start: 119_000, title: "Podlove", href: "http://podlove.org/"},
             %Chapter{
               start: 599_000,
               title: "Podlove Logo",
               image: "http://podlove.org/logo.jpg"
             },
             %Chapter{
               start: 2_511_792,
               title: "Erratum: Wir meinen Steve Jackson",
               image: "http://fanboys.fm/assets/123/Chapter07.jpeg",
               href:
                 "https://en.wikipedia.org/wiki/Steve_Jackson_(American_game_designer)#The_two_\"Steve_Jacksons\""
             }
           ]
  end

  @mp4chaps_chapters ~S"""
  00:00:00 Intro
  00:01:59 Podlove <http://podlove.org/>
  """
  test "decode mp4chaps" do
    assert Chapters.decode(@mp4chaps_chapters, :mp4chaps) == [
             %Chapter{start: 0, title: "Intro"},
             %Chapter{start: 119_000, title: "Podlove", href: "http://podlove.org/"}
           ]
  end

  @json_chapters ~S"""
  [
  	{ "start": "00:00:00.000", "title": "Intro"},
  	{ "start": "00:01:59.000", "title": "Podlove", "href": "http://podlove.org/"},
    { "start": "09:59", "title": "Podlove Logo", "image": "http://podlove.org/logo"},
    { "start": "00:41:51.792", "title": "Erratum: Wir meinen Steve Jackson", "href": "https://en.wikipedia.org/wiki/Steve_Jackson_(American_game_designer)#The_two_\"Steve_Jacksons\"", "image": "http://fanboys.fm/assets/123/Chapter07.jpeg"}
  ]
  """

  test "decode json" do
    assert Chapters.decode(@json_chapters, :json) == [
             %Chapter{start: 0, title: "Intro"},
             %Chapter{start: 119_000, title: "Podlove", href: "http://podlove.org/"},
             %Chapter{start: 599_000, title: "Podlove Logo", image: "http://podlove.org/logo"},
             %Chapter{
               start: 2_511_792,
               title: "Erratum: Wir meinen Steve Jackson",
               image: "http://fanboys.fm/assets/123/Chapter07.jpeg",
               href:
                 "https://en.wikipedia.org/wiki/Steve_Jackson_(American_game_designer)#The_two_\"Steve_Jacksons\""
             }
           ]
  end

  test "encode json" do
    assert Chapters.encode(
             [
               %Chapter{start: 0, title: "Intro"},
               %Chapter{start: 119_000, title: "Podlove", href: "http://podlove.org/"},
               %Chapter{start: 599_000, title: "Podlove Logo", image: "http://podlove.org/logo"},
               %Chapter{
                 start: 2_511_792,
                 title: "Erratum: Wir meinen Steve Jackson",
                 image: "http://fanboys.fm/assets/123/Chapter07.jpeg",
                 href:
                   "https://en.wikipedia.org/wiki/Steve_Jackson_(American_game_designer)#The_two_\"Steve_Jacksons\""
               }
             ],
             :json
           )
           |> Chapters.decode(:json) == Chapters.decode(@json_chapters, :json)
  end

  @psc_chapters ~S"""
  <?xml version="1.0" encoding="UTF-8"?>
  <psc:chapters version="1.2" xmlns:psc="http://podlove.org/simple-chapters">
    <psc:chapter start="00:00:00.000" title="Intro"/>
    <psc:chapter start="00:01:59.000" title="Podlove" href="http://podlove.org/"/>
    <psc:chapter start="00:09:59.000" title="Podlove Logo" image="http://podlove.org/logo.jpg"/>
    <psc:chapter start="00:41:51.792" title="Erratum: Wir meinen Steve Jackson" href='https://en.wikipedia.org/wiki/Steve_Jackson_(American_game_designer)#The_two_"Steve_Jacksons"' image="http://fanboys.fm/assets/123/Chapter07.jpeg"/>
  </psc:chapters>
  """

  test "encode psc" do
    assert Chapters.encode(
             [
               %Chapter{start: 0, title: "Intro"},
               %Chapter{start: 119_000, title: "Podlove", href: "http://podlove.org/"},
               %Chapter{
                 start: 599_000,
                 title: "Podlove Logo",
                 image: "http://podlove.org/logo.jpg"
               },
               %Chapter{
                 start: 2_511_792,
                 title: "Erratum: Wir meinen Steve Jackson",
                 image: "http://fanboys.fm/assets/123/Chapter07.jpeg",
                 href:
                   "https://en.wikipedia.org/wiki/Steve_Jackson_(American_game_designer)#The_two_\"Steve_Jacksons\""
               }
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
               %Chapter{start: 0, title: "Intro"},
               %Chapter{start: 119_000, title: "Podlove", href: "http://podlove.org/"}
             ],
             :mp4chaps
           )
           |> String.trim() ==
             String.trim(@mp4chaps_chapters)
  end
end
