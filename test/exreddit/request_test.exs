defmodule ExReddit.Api.RequestTest do
  use ExUnit.Case
  doctest ExReddit.Request

  alias ExReddit.Request
  alias HTTPotion.Response

  @moduletag :reddit_api
  @moduletag :request

  test "get with uri" do
    %Response{body: body, status_code: 200} =
      Request.get({:uri, "/r/learnprogramming/new" })

    {:ok, response} = Poison.decode(body)
    assert length(Map.keys(response)) > 0
  end
end
