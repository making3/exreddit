defmodule ExReddit.Requests.Server do
  use GenServer

  alias ExReddit.Requests.Request

  def start_link(options) do
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def handle_call({:request, params}, from, queue) do
    {:noreply, :queue.in({from, params}, queue)}
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

  defp process_pop({{:value, {from, {uri, token, opts}}}, queue}) do
    # TODO: Allow other types of request (post, put, del)
    reply = Request.get(uri, token, opts)
    GenServer.reply(from, reply)
    {:noreply, queue}
  end

  defp get_rate_limit_delay() do
    Application.get_env(:exreddit, :api_rate_limit_delay)
  end
end
