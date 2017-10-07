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

  test "get_new_threads/2 test", state do
    {:ok, response} = Subreddit.get_new_threads(state[:token], "learnprogramming")
    threads = response |> Map.get("children")
    assert length(threads) == 25
  end

  test "get_new_threads/3 with [limit: 1] test", state do
    {:ok, response} = Subreddit.get_new_threads(state[:token], "learnprogramming", [limit: 1])
    threads = response |> Map.get("children")
    assert length(threads) == 1
  end

  test "get_new_threads/2 should fail with empty subreddit", state do
    {:error, _} = Subreddit.get_new_threads(state[:token], "")
  end

  test "get_comments/3 test", state do
    {:ok, comments} = Subreddit.get_comments(state[:token], "pics", "73w8zb")
    assert length(comments) > 0
  end

  test "get_comments/3 should fail with empty subreddit", state do
    {:error, _} = Subreddit.get_comments(state[:token], "", "74dfgq")
  end

  test "get_comments/3 should fail with empty thread_id", state do
    {:error, _} = Subreddit.get_comments(state[:token], "learnprogramming", "")
  end
end
