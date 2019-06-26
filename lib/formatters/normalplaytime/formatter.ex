defmodule Chapters.Formatters.Normalplaytime.Formatter do
  @doc """
  Format milliseconds to a normal playtime string

  ## Examples

    iex> format(2_511_792)
    "00:41:51.792"

  """

  @spec format(integer()) :: binary()
  def format(time) when is_integer(time) do
    Time.add(~T[00:00:00], time, :millisecond)
    |> Time.truncate(:millisecond)
    |> Time.to_string()
  end
end
