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
  """

  def to_keylist(%__MODULE__{} = chapter) do
    [
      start:
        chapter.start
        |> Chapters.Formatters.Normalplaytime.Formatter.format(),
      title: chapter.title
    ]
    |> maybe_put(:href, chapter.href)
    |> maybe_put(:image, chapter.image)
  end

  defp maybe_put(keylist, _key, nil), do: keylist
  defp maybe_put(keylist, key, value), do: List.keystore(keylist, key, 0, {key, value})
end
