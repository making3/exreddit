require Poison
require HTTPotion

defmodule ExReddit.Api do
  def get_comments(token, subreddit, thread_id, opts) do
    request({:uri, "/r/#{subreddit}/comments/#{thread_id}"}, token, opts)
    |> Map.get(:body)
    |> get_request_body
  end

  def request(params, token, opts \\ []) do
    response = GenServer.call(RequestServer, {:request, {params, token, opts}})
    respond(token, response)
  end

  defp respond(token, %HTTPotion.Response{status_code: 302, headers: %HTTPotion.Headers{hdrs: %{"location" => location}}}) do
    request({:url, location}, token)
  end
  defp respond(_, %HTTPotion.Response{body: %{"error" => error_message}, status_code: 200}) do
    {:error, error_message}
  end
  defp respond(_, %HTTPotion.Response{body: body, status_code: 200}) do
    Poison.decode(body)
  end
  defp respond(_, %HTTPotion.Response{body: body, status_code: status_code}) when status_code not in 200..299 do
    case Poison.decode(body) do
      {:ok, decoded_body} ->
        error_message = Map.get(decoded_body, "message")
        {:error, error_message}
      other -> other
    end
  end
  defp respond(_, %HTTPotion.ErrorResponse{message: error_message}) do
    {:error, error_message}
  end

  def get_request_body(""), do: ""
  def get_request_body(body), do: Poison.decode(body) |> ok

  defp ok({:ok, result}), do: result
end
