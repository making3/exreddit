defmodule ExReddit.OAuthTest do
  use ExUnit.Case
  doctest ExReddit.OAuth

  alias ExReddit.OAuth

  @moduletag :reddit_api
  @moduletag :oauth

  setup do
    Application.put_env(:exreddit, :username, System.get_env("REDDIT_USER"))
    Application.put_env(:exreddit, :client_id, System.get_env("REDDIT_CLIENT_ID"))
  end

  test "get_token/0 should return {:ok, token}" do
    {:ok, token} = OAuth.get_token()
    assert byte_size(token) > 0
  end

  test "get_token/0 should return {:error, message} on bad auth data" do
    Application.put_env(:exreddit, :username, "")
    {:error, _} = OAuth.get_token()
    Application.put_env(:exreddit, :client_id, "")
    {:error, _} = OAuth.get_token()
  end

  test "get_token!/0 should return a token" do
    size =
      OAuth.get_token!()
      |> byte_size

    assert size > 0
  end

  test "get_token!/0 should throw on bad auth data" do
    Application.put_env(:exreddit, :username, "")
    assert OAuth.get_token!() == nil
  end
end
