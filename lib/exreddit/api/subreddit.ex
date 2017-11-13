defmodule ExReddit.Api.Subreddit do
  import ExReddit.Api

  require Poison
  require HTTPotion

  def get_sticky(token, subreddit, num \\ 1) do
    request({:uri, "/r/#{subreddit}/about/sticky"}, token, [num: num])
  end
  def get_sticky!(token, subreddit, num \\ 1) do
    case request({:uri, "/r/#{subreddit}/about/sticky"}, token, [num: num]) do
      {:ok, response} -> response
      other -> other
    end
  end

  def get_new_threads(token, subreddit, opts \\ []) do
    request({:uri, "/r/#{subreddit}/new"}, token, opts)
    |> get_request_data
  end

  def get_comments(token, subreddit, thread_id, opts \\ []) do
    request({:uri, "/r/#{subreddit}/comments/#{thread_id}"}, token, opts)
  end
end
