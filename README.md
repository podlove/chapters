# Chapters

[![Build Status](https://travis-ci.org/podlove/chapters.svg?branch=master)](https://travis-ci.org/podlove/chapters)

[Online Documentation](https://hexdocs.pm/chapters).

<!-- MDOC !-->

Podcast chapter parser and formatter.

Supports:

- [Podlove Simple Chapters](https://podlove.org/simple-chapters/) (xml/psc)
- mp4chaps
- JSON

## Basic Usage

Decode from mp4chaps

```elixir
iex(1)> chapters = Chapters.decode(~S"""
...(1)> 00:00:00 Intro
...(1)> 00:01:59 Podlove <http://podlove.org/>
...(1)> """, :mp4chaps)
[
  %Chapters.Chapter{href: nil, image: nil, start: 0, title: "Intro"},
  %Chapters.Chapter{
    href: "http://podlove.org/",
    image: nil,
    start: 119000,
    title: "Podlove"
  }
]

```

Encode to PSC

```elixir
iex> Chapters.encode(chapters, :psc) |> IO.puts                 
<?xml version="1.0" encoding="UTF-8"?>
<psc:chapters version="1.2" xmlns:psc="http://podlove.org/simple-chapters">
  <psc:chapter start="00:00:00.000" title="Intro"/>
  <psc:chapter start="00:01:59.000" title="Podlove" href="http://podlove.org/"/>
</psc:chapters>
```

Encode to mp4chaps

```elixir
iex> Chapters.encode(chapters, :mp4chaps) |> IO.puts
00:00:00.000 Intro
00:01:59.000 Podlove <http://podlove.org/>
```

Encode to JSON

```elixir
iex> Chapters.encode(chapters, :json) |> IO.puts                
[{"start":"00:00:00.000","title":"Intro"},{"start":"00:01:59.000","title":"Podlove","href":"http://podlove.org/"}]
```

<!-- MDOC !-->

## Installation

The package can be installed by adding `chapters` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:chapters, "~> 1.0"}
  ]
end
```

## License

Chapters is [MIT Licensed][license].

[license]: https://github.com/podlove/chapters/blob/master/LICENSE
