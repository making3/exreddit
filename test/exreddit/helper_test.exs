defmodule ExReddit.HelperTest do
  use ExUnit.Case
  doctest ExReddit.Helper

  @moduletag :reddit_api
  @moduletag :helper

  setup_all do
    token = Application.get_env(:exreddit, :token)
    {:ok, token: token}
  end

  test "test get_thread_selftext", state do
    # TODO: If possible, remove the dependency on the api
    response = ExReddit.Api.Subreddit.get_sticky!(state[:token], "learnprogramming", 1)

    selftext = ExReddit.Helper.get_thread_selftext(response)
    assert byte_size(selftext) > 0
  end
end
