defmodule Chapters.Formatters.Json.Formatter do
  import Jason.Helpers
  alias Chapters.Chapter

  @spec format([Chapter.t()]) :: binary()
  def format(input) do
    input
    |> Enum.map(fn chapter ->
      chapter_map = chapter |> Chapter.to_keylist() |> Map.new()

      # to facilitate ordering, the list of keys to take needs to be static
      case {chapter.image, chapter.href} do
        {nil, nil} -> json_map_take(chapter_map, [:start, :title])
        {_im, nil} -> json_map_take(chapter_map, [:start, :title, :image])
        {nil, _ur} -> json_map_take(chapter_map, [:start, :title, :href])
        {_im, _ur} -> json_map_take(chapter_map, [:start, :title, :href, :image])
      end
    end)
    |> Jason.encode!()
  end
end
