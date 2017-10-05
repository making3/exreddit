defmodule ExReddit.Helpers.Comments do
  def get_main(comments) do
    comments
    |> Enum.find(fn (comment) -> Map.get(comment, "kind") == "Listing" end)
    |> Map.get("data")
    |> Map.get("children")
    |> List.first
    |> Map.get("data")
  end

  # TODO: Implement get_replies func
end
