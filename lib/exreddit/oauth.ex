defmodule ExReddit.OAuth do
  alias HTTPoison.{Response, Error}

  require Poison

  def get_token, do: request_token() |> parse()

  defp parse({:ok, %HTTPoison.Response{body: body, status_code: code}}),
    do: Poison.decode(body) |> parse_body(code)

  defp parse(%Error{reason: error}),
    do: {:error, error}

  defp parse(unknown),
    do: {:unknown, unknown}

  defp parse_body({:ok, %{"access_token" => token}}, 200),
    do: {:ok, token}

  defp parse_body({:ok, %{"error" => code, "message" => mesage} = resp}, _),
    do: {:error, resp}

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
    config = get_config()

    HTTPoison.post(
      "https://www.reddit.com/api/v1/access_token", 
      "grant_type=password&username=#{config[:username]}&password=#{config[:password]}", 
      [
        {"User-Agent", "exreddit-api-wrapper"},
        {"Content-Type", "application/x-www-form-urlencoded"}
      ],
      hackney: [basic_auth: {config[:client_id], config[:secret]}]
      #basic_auth: {config[:client_id], config[:secret]}
    ) |> IO.inspect()
  end

  defp request_token! do
    config = get_config()

    HTTPoison.post!(
      "https://www.reddit.com/api/v1/access_token", 
      "grant_type=password&username=#{config[:username]}&password=#{config[:password]}", 
      [
        {"User-Agent", "exreddit-api-wrapper"},
        {"Content-Type", "application/x-www-form-urlencoded"}
      ],
      hackney: [basic_auth: {config[:client_id], config[:secret]}]
    )
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
