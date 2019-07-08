defmodule Chapters.Chapter do
  @moduledoc """
  One chapter entry.
  """

  @typedoc """
  * `start` - milliseconds since start. e.g. "00:01:30.000" would be `90_000` (mandatory)
  * `title` - title of that chapter (mandatory)
  * `href` - link to jump to that chapter (optional)
  * `image` - url to a chapter image (optional)
  """

  @type t :: %__MODULE__{
          start: non_neg_integer,
          title: String.t(),
          href: String.t() | nil,
          image: String.t() | nil
        }
  defstruct start: 0,
            title: "",
            href: nil,
            image: nil

  @doc """
  Produces an ordered keylist `:start, :title, :href, :image` with the start already formatted top a normal playtime for use in output formats

  iex> %Chapters.Chapter{href: "//foo", image: nil, start: 1234, title: "Title"} |> Chapter.to_keylist()
  [start: "00:00:01.234", title: "Title", href: "//foo"]

  iex> %Chapters.Chapter{href: "", image: "//foo.jpeg", start: 1234, title: "Title"} |> Chapter.to_keylist()
  [start: "00:00:01.234", title: "Title", image: "//foo.jpeg"]
  """

  def to_keylist(%__MODULE__{} = chapter) do
    chapter = sanitize(chapter)

    [
      start:
        chapter.start
        |> Chapters.Formatters.Normalplaytime.Formatter.format(),
      title: chapter.title
    ]
    |> maybe_put(:href, chapter.href)
    |> maybe_put(:image, chapter.image)
  end

  @doc """
  Sanitizes the href and image values. Trims them and nils them out if they are an empty string.

      iex> %Chapters.Chapter{href: " //foo ", image: " ", start: 0, title: "Title"} |> Chapter.sanitize()
      %Chapters.Chapter{href: "//foo", image: nil, start: 0, title: "Title"}

      iex> %Chapters.Chapter{href: "   ", image: "  ", start: 0, title: "Title"} |> Chapter.sanitize()
      %Chapters.Chapter{href: nil, image: nil, start: 0, title: "Title"}

  """

  def sanitize(chapter = %__MODULE__{}) do
    [:href, :image]
    |> Enum.reduce(chapter, fn key, acc ->
      case Map.get(acc, key) do
        nil ->
          acc

        value ->
          case String.trim(value) do
            "" -> Map.put(acc, key, nil)
            ^value -> acc
            trimmed -> Map.put(acc, key, trimmed)
          end
      end
    end)
  end

  defp maybe_put(keylist, _key, nil), do: keylist
  defp maybe_put(keylist, key, value), do: List.keystore(keylist, key, 0, {key, value})
end
