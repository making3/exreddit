defmodule ExReddit.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exreddit,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ExReddit, []},
      applications: [:httpoison],
      extra_applications: [:logger, :poison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:poison, "~> 4.0"}
    ]
  end
end
