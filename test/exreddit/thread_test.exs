defmodule ExReddit.ThreadTest do
  use ExUnit.Case
  doctest ExReddit.Thread

  alias ExReddit.Thread

  setup do
    json =
      Path.expand('./test/examples/submission.json' )
      |> File.read!()
      |> Poison.decode!()

    {:ok, json: json}
  end

  test "should parse response", state do
    {thread, comments} = Thread.parse_api_response(state[:json])

    assert thread["subreddit"] == "javascript"
    assert thread["domain"] == "2ality.com"
    assert length(comments) == 2
    assert List.first(comments)["id"] == "dpng2il"
  end
end
