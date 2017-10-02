require Poison
require HTTPotion

defmodule ExReddit.Api.Subreddit do
  import ExReddit.Api

  def get_sticky(token, subreddit, num \\ 1) do
    request({:uri, "/r/#{subreddit}/about/sticky"}, token, [num: num])
      |> get_thread_from_result
  end

  def get_new_threads(token, subreddit, opts \\ []) do
    request({:uri, "/r/#{subreddit}/new"}, token, opts)
      |> Map.get(:body)
      |> get_request_body
  end
end
