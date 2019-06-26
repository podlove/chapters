defmodule Chapters.Formatters.Mp4chaps.Formatter do
  alias Chapters.Chapter

  @spec format([Chapter.t()]) :: binary()
  def format(input) do
    input
    |> Enum.map(fn chapter ->
      chapter
      |> Chapter.to_keylist()
      |> Enum.map(fn
        {:start, start} -> start
        {:title, title} -> title
        {:href, href} -> "<#{href}>"
        _ -> nil
      end)
      # remove nils
      |> Enum.filter(& &1)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
  end
end
