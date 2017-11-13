defmodule ExReddit.Requests.Request do
  @reddit_auth_url "https://oauth.reddit.com"

  def get_with_token(uri, token, options \\ []) do
    full_url = get_full_token_url(uri, options)
    headers = get_headers(token)
    HTTPotion.get(full_url, headers)
  end

  defp get_full_token_url({:url, url}, options) do
    query = get_query(options)
    "#{url}/#{query}"
  end

  defp get_full_token_url({:uri, endpoint}, options) do
    url = @reddit_auth_url
    |> URI.parse()
    |> URI.merge(endpoint)
    |> URI.to_string()
    get_full_token_url({:url, url}, options)
  end

  defp get_query(options) do
    query = options
    |> Enum.map(fn {key, value} -> "#{key}=#{value}" end) # TODO: Can this be cleaned up / shortened?
    |> Enum.join("&")
    "?#{query}"
  end

  defp get_headers(token) do
    [
      headers: [
        "User-Agent": "exreddit-api-wrapper/0.1 by yeamanz",
        "Authorization": "bearer #{token}"
      ]
    ]
  end
end
