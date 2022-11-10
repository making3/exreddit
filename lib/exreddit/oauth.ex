defmodule ExReddit.OAuth do
  alias HTTPotion.{Response, ErrorResponse}

  require Poison

  def get_token, do: request_token() |> parse()

  defp parse(%Response{body: body, status_code: code}),
    do: Poison.decode(body) |> parse_body(code)

  defp parse(%ErrorResponse{message: error}),
    do: {:error, error}

  defp parse(unknown),
    do: {:unknown, unknown}

  defp parse_body({:ok, %{"access_token" => token}}, 200),
    do: {:ok, token}

  defp parse_body({:ok, %{"error" => error}}, _),
    do: {:error, error}

  defp parse_body({:ok, %{"message" => message}}, _),
    do: {:error, message}

  defp parse_body({_, unknown}, _),
    do: {:unknown, unknown}

  def get_token! do
    request_token!().body
    |> Poison.decode!()
    |> Map.get("access_token")
  end

  defp request_token do
    headers = get_auth_headers()
    opts = headers ++ [timeout: 30_000]
    HTTPotion.post("https://www.reddit.com/api/v1/access_token", opts)
  end

  defp request_token! do
    headers = get_auth_headers()
    opts = headers ++ [timeout: 30_000]
    HTTPotion.post!("https://www.reddit.com/api/v1/access_token", opts)
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
