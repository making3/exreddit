defmodule ExReddit.Request do
  @reddit_url "https://www.reddit.com"
  @reddit_auth_url "https://oauth.reddit.com"

  def get(uri, options \\ []) do
    url = get_url(uri, options)
    HTTPotion.get(url)
  end

  def get_with_token(uri, token, options \\ []) do
    url = get_token_url(uri, options)
    headers = get_headers(token)
    HTTPotion.get(url, headers)
  end

  defp get_url({:url, url}, options) do
    get_url_with_query(url, options)
  end

  defp get_url({:uri, uri}, options) do
    url = get_full_url(@reddit_url, uri) <> ".json"
    get_url({:url, url}, options)
  end

  defp get_token_url({:url, url}, options) do
    get_url_with_query(url, options)
  end

  defp get_token_url({:uri, endpoint}, options) do
    url = get_full_url(@reddit_auth_url, endpoint)
    get_token_url({:url, url}, options)
  end

  defp get_url_with_query(url, options) do
    query = get_query(options)
    "#{url}#{query}"
  end

  defp get_full_url(url, path) do
    url
    |> URI.parse()
    |> URI.merge(path)
    |> URI.to_string()
  end

  defp get_query(options) do
    query =
      options
      # TODO: Can this be cleaned up / shortened?
      |> Enum.map(fn {key, value} -> "#{key}=#{value}" end)
      |> Enum.join("&")

    "?#{query}"
  end

  defp get_headers(token) do
    [
      headers: [
        "User-Agent": "exreddit-api-wrapper/0.1 by yeamanz",
        Authorization: "bearer #{token}"
      ]
    ]
  end
end
