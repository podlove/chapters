defmodule Chapters.Formatters.Normalplaytime.Formatter do
  @spec format(integer()) :: binary()
  def format(time) when is_integer(time) do
    Time.add(~T[00:00:00], time, :millisecond)
    |> Time.truncate(:millisecond)
    |> Time.to_string()
  end
end
