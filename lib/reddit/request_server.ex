defmodule RequestServer do
  use GenServer
  @delay_seconds 1

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [ name: RequestServer ])
  end

  def start_link(options) do
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def handle_call({:request, params}, from, queue) do
    {:noreply, :queue.in({from, params}, queue)}
  end

  def init(_) do
    :timer.send_interval(@delay_seconds * 1000, :tick)
    {:ok, :queue.new}
  end

  def handle_info(:tick, queue) do
    process_pop(:queue.out(queue))
  end

  defp process_pop({:empty, queue}), do: {:noreply, queue}
  defp process_pop({{:value, {from, {uri, token, opts}}}, queue}) do
    reply = reddit_request(uri, token, opts)
    GenServer.reply(from, reply)
    {:noreply, queue}
  end

  defp reddit_request({:url, url}, token, options) do
    query = get_query(options)
    url_with_query = "#{url}/#{query}"
    headers = get_headers(token)
    HTTPotion.get(url_with_query, headers)
  end

  defp reddit_request({:uri, endpoint}, token, options) do
    url = "https://oauth.reddit.com#{endpoint}"
    reddit_request({:url, url}, token, options)
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
