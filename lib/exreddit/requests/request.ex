defmodule ExReddit.Requests.Request do
  def get({:url, url}, token, options) do
    query = get_query(options)
    url_with_query = "#{url}/#{query}"
    headers = get_headers(token)
    HTTPotion.get(url_with_query, headers)
  end

  def get({:uri, endpoint}, token, options) do
    url = "https://oauth.reddit.com#{endpoint}"
    get({:url, url}, token, options)
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
