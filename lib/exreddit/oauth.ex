
defmodule ExReddit.OAuth do
  alias HTTPotion.{Response, ErrorResponse}

  require Poison

  def get_token do
    case request_token() do
      %Response{body: body, status_code: 200} ->
        get_access_token(body)
      %Response{body: body, status_code: status_code} when status_code not in 200..299 ->
        case Poison.decode(body) do
          {:ok, decoded_body} ->
            error_message = Map.get(decoded_body, "message")
            {:error, error_message}
          other -> other
        end
      %ErrorResponse{message: error_message} ->
        {:error, error_message}
      error ->
        error
    end
  end

  defp get_access_token(body) do
    case Poison.decode(body) do
      {:ok, %{"access_token" => token}} ->
        {:ok, token}
      {:ok, %{"error" => error_message}} ->
        {:error, error_message}
      error ->
        error
    end
  end

  def get_token! do
    request_token!().body
    |> Poison.decode!()
    |> Map.get("access_token")
  end

  defp request_token do
    headers = get_auth_headers()
    HTTPotion.post("https://www.reddit.com/api/v1/access_token", headers)
  end

  defp request_token! do
    headers = get_auth_headers()
    HTTPotion.post!("https://www.reddit.com/api/v1/access_token", headers)
  end

  defp get_auth_headers do
    config = get_config()
    [
      body: "grant_type=password&username=#{config[:username]}&password=#{config[:password]}",
      headers: [
        "User-Agent": "exreddit-api-wrapper",
        "Content-Type": "application/x-www-form-urlencoded"
      ],
      basic_auth: {config[:client_id], config[:secret]}
    ]
  end

  defp get_config do
    %{
      username: Application.get_env(:exreddit, :username),
      password: Application.get_env(:exreddit, :password),
      client_id: Application.get_env(:exreddit, :client_id),
      secret: Application.get_env(:exreddit, :secret)
    }
  end
end
