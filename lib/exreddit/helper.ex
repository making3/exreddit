defmodule ExReddit.Helper do
  def get_thread_selftext(thread) do
    thread
    |> List.first()
    |> Map.get("data")
    |> Map.get("children")
    |> List.first()
    |> Map.get("data")
    |> Map.get("selftext")
  end
end
