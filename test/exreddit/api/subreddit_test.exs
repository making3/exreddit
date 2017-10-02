alias ExReddit.Api.Subreddit, as: Subreddit

defmodule ExReddit.Api.SubredditTest do
  use ExUnit.Case
  doctest ExReddit.Api.Subreddit

  @moduletag :reddit_api
  @moduletag :subreddit

  setup_all do
    token = ExReddit.OAuth.get_token!
    {:ok, token: token}
  end

  test "get_sticky test", state do
    dater = Subreddit.get_sticky(state[:token], "learnprogramming", 1)
    IO.inspect(dater)
  end
end
