defmodule ExReddit.Api do
  require Poison

  alias ExReddit.Requests.Server, as: RequestServer
  alias HTTPotion.{Response, Headers, ErrorResponse}

  def get(params, token, opts \\ []) do
    response = RequestServer.get(params, token, opts)
    respond(token, response)
  end

  defp respond(token, %Response{status_code: 302, headers: %Headers{hdrs: %{"location" => location}}}) do
    get({:url, location}, token)
  end
  defp respond(_, %Response{body: %{"error" => error_message}, status_code: 200}) do
    {:error, error_message}
  end
  defp respond(_, %Response{body: body, status_code: 200}) do
    Poison.decode(body)
  end
  defp respond(_, %Response{body: body, status_code: status_code}) when status_code not in 200..299 do
    case Poison.decode(body) do
      {:ok, decoded_body} ->
        error_message = Map.get(decoded_body, "message")
        {:error, error_message}
      other -> other
    end
  end
  defp respond(_, %ErrorResponse{message: error_message}) do
    {:error, error_message}
  end

  def get_request_data({:ok, response}) do
    response_data = response |> Map.get("data")
    {:ok, response_data}
  end
  def get_request_data(unknown) do
    {:error, unknown}
  end
end
