defmodule Chapters.Chapter do
  @moduledoc """
  One chapter entry.
  """

  @typedoc """
  * `time` - milliseconds since start. e.g. "00:01:30.000" would be `90_000` (mandatory)
  * `title` - title of that chapter (mandatory)
  * `image` - url to a chapter image (optional)
  * `url` - link to jump to that chapter (optional)
  """

  @type t :: %__MODULE__{
          time: non_neg_integer,
          title: String.t(),
          url: String.t() | nil,
          image: String.t() | nil
        }
  defstruct time: 0,
            title: "",
            url: nil,
            image: nil

  @doc """
      Produces an ordered keylist `:start, :title, :href, :image` for use in json or psc
  """

  def to_keylist(%__MODULE__{} = chapter) do
    [
      start:
        chapter.time
        |> Chapters.Formatters.Normalplaytime.Formatter.format(),
      title: chapter.title
    ]
    |> maybe_put(:href, chapter.url)
    |> maybe_put(:image, chapter.image)
  end

  defp maybe_put(keylist, _key, nil), do: keylist
  defp maybe_put(keylist, key, value), do: List.keystore(keylist, key, 0, {key, value})
end
