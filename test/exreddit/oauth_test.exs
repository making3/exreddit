alias ExReddit.OAuth, as: OAuth

defmodule ExReddit.OAuthTest do
  use ExUnit.Case
  doctest ExReddit.OAuth

  @moduletag :reddit_api
  @moduletag :oauth

  setup do
    Application.put_env(:exreddit, :username, System.get_env("REDDIT_USER"))
  end

  test "get_token/0 should return {:ok, token}" do
    {:ok, token} = OAuth.get_token
    assert byte_size(token) > 0
  end

  test "get_token/0 should return {:error, message} on bad auth data" do
    Application.put_env(:exreddit, :username, "")
    {:error, _} = OAuth.get_token
  end

  test "get_token!/0 should return a token" do
    size = OAuth.get_token!
      |> byte_size
    assert size > 0
  end

  test "get_token!/0 should throw on bad auth data" do
    Application.put_env(:exreddit, :username, "")
    assert OAuth.get_token! == nil
  end
end
