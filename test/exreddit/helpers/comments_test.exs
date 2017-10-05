defmodule ExReddit.Helpers.CommentsTest do
  use ExUnit.Case
  doctest ExReddit.Helpers.Comments

  @moduletag :reddit_api
  @moduletag :helper_comments

  setup_all do
    token = Application.get_env(:exreddit, :token)
    {:ok, token: token}
  end

  test "test get_main", state do
    {:ok, response} = ExReddit.Api.Subreddit.get_comments(state[:token], "learnprogramming", "61oly8")

    main_comment = ExReddit.Helpers.Comments.get_main(response)
    assert main_comment != nil
  end
end
