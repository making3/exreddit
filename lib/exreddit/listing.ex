defmodule ExReddit.Listing do
  def parse_api_response([submission_listing, comments_listing] ) do
    submission = get_submission(submission_listing)
    comments = get_comments(comments_listing)

    {submission, comments}
  end

  defp get_submission(listing) do
    listing
    |> Map.get("data")
    |> Map.get("children")
    |> List.first()
    |> Map.get("data")
  end

  defp get_comments(listing) do
    listing
    |> Map.get("data")
    |> Map.get("children")
    |> Enum.map(fn child -> child["data"] end)
  end
end
