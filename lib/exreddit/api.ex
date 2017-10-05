require Poison
require HTTPotion

defmodule ExReddit.Api do
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

  def get_request_data({:ok, response}) do
      response_data = response |> Map.get("data")
      {:ok, response_data}
  end
  def get_request_data(other) do
    other
  end
end
