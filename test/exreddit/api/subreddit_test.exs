alias ExReddit.Api.Subreddit, as: Subreddit

defmodule ExReddit.Api.SubredditTest do
  use ExUnit.Case
  doctest ExReddit.Api.Subreddit

  @moduletag :reddit_api
  @moduletag :subreddit

  setup_all do
    token = Application.get_env(:exreddit, :token)
    {:ok, token: token}
  end

  test "get_sticky test", state do
    {:ok, response} = Subreddit.get_sticky(state[:token], "learnprogramming", 1)
    assert length(response) > 0
  end

  test "get_sticky! test", state do
    response = Subreddit.get_sticky!(state[:token], "learnprogramming", 1)
    assert length(response) > 0
  end
end
