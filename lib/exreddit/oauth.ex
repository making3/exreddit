defmodule ExReddit.OAuth do
  def get_token do
    request_token() |> get_body
  end

  defp get_body(%HTTPotion.Response{body: body, status_code: 200}) do
    Poison.decode(body) |> get_access_token
  end
  defp get_body(%HTTPotion.ErrorResponse{message: error}) do
    {:error, error}
  end

  defp get_access_token({:ok, %{"error" => error_message}}) do
    {:error, error_message}
  end
  defp get_access_token({:ok, %{"access_token" => token}}) do
    {:ok, token}
  end
  defp get_access_token(error) do
    error
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
