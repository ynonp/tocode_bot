defmodule App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.3",
      default_task: "server",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      applications: [:logger, :nadia, :swarm],
      mod: {App, []}
    ]
  end

  defp deps do
    [
      {:nadia, "~> 0.7.0"},
      {:httpoison, "~> 1.7.0"},
      {:poison, "~> 3.1"},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.0"},
      {:floki, "~> 0.20.0"},
    ]
  end

  defp aliases do
    [server: "run --no-halt"]
  end
end
