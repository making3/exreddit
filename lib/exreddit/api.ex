require Poison
require HTTPotion

defmodule ExReddit.Api do
  def get_stickied_thread(token, subreddit, num) do
    location = request({:uri, "/r/#{subreddit}/about/sticky"}, token, [num: num])
      |> Map.get(:headers)
      |> Map.get(:hdrs)
      |> Map.get("location")

    request({:url, location}, token)
      |> Map.get(:body)
      |> Poison.decode
      |> get_thread_from_result
  end

  def get_new_threads(token, subreddit, opts \\ []) do
    request({:uri, "/r/#{subreddit}/new"}, token, opts)
      |> Map.get(:body)
      |> get_request_body
  end

  def get_comments(token, subreddit, thread_id, opts) do
    # TODO: Remove limit, or find a way to process more than the limit (I'm sure there is a max..limit)
    request({:uri, "/r/#{subreddit}/comments/#{thread_id}"}, token, opts)
      |> Map.get(:body)
      |> get_request_body
  end

  defp request(params, token, opts \\ []) do
    GenServer.call(RequestServer, {:request, {params, token, opts}})
  end

  defp get_request_body(""), do: ""
  defp get_request_body(body), do: Poison.decode(body) |> ok

  defp ok({:ok, result}), do: result
  defp get_thread_from_result({:ok, [thread, _]}), do: thread
end
