defmodule ExReddit do
  use Application

  def start(_type, _args) do
    ExReddit.Supervisor.start_link()
  end
end
