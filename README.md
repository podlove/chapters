# Chapters

Podcast chapter parser and formatter.

Supports:

- [Podlove Simple Chapters](https://podlove.org/simple-chapters/) (xml/psc)
- mp4chaps
- JSON

## Installation

The package can be installed by adding `chapters` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:chapters, "~> 0.1"}
  ]
end
```

## Basic Usage

Decode from mp4chaps

```elixir
iex(1)> chapters = Chapters.decode(~S"""
...(1)> 00:00:00 Intro
...(1)> 00:01:59 Podlove <http://podlove.org/>
...(1)> """, :mp4chaps)
[
  %Chapters.Chapter{image: nil, time: 0, title: "Intro", url: nil},
  %Chapters.Chapter{
    image: nil,
    time: 119000,
    title: "Podlove",
    url: "http://podlove.org/" 
  }
]
```

Encode to PSC

```elixir
iex> Chapters.encode(chapters, :psc) |> IO.puts                 
<?xml version="1.0" encoding="UTF-8"?>
<psc:chapters version="1.2" xmlns:psc="http://podlove.org/simple-chapters">
  <psc:chapter start="00:00:00.000" title="Intro"/>
  <psc:chapter href="http://podlove.org/" start="00:01:59.000" title="Podlove"/>
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
[{"start":"00:00:00.000","title":"Intro"},{"href":"http://podlove.org/","start":"00:01:59.000","title":"Podlove"}]
```

## License

Chapters is [MIT Licensed][license].

[license]: https://github.com/podlove/chapters/blob/master/LICENSE
