defmodule ExReddit.Requests.Server do
  use GenServer

  alias ExReddit.Request

  ## Client API
  def start_link(options) do
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def get_with_token(uri, token, opts) do
    req = fn ->
      Request.get_with_token(uri, token, opts)
    end
    GenServer.call(__MODULE__, {:request, req})
  end

  ## Server API
  def handle_call({:request, request}, from, queue) do
    {:noreply, :queue.in({from, request}, queue)}
  end

  def init(_) do
    :timer.send_interval(get_rate_limit_delay(), :tick)
    {:ok, :queue.new}
  end

  def handle_info(:tick, queue) do
    process_pop(:queue.out(queue))
  end

  defp process_pop({:empty, queue}) do
    {:noreply, queue}
  end

  defp process_pop({{:value, {from, request}}, queue}) do
    reply = request.()
    GenServer.reply(from, reply)
    {:noreply, queue}
  end

  defp get_rate_limit_delay() do
    Application.get_env(:exreddit, :api_rate_limit_delay)
  end
end
