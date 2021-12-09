defmodule ITJ.MixProject do
  use Mix.Project

  def project do
    [
      app: :itj,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools, :os_mon],
      mod: {ITJ.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sqlite3, "~> 0.7.1"},
      {:ecto, "~> 3.7.1"},
      {:floki, "~> 0.32.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:phoenix_html, "~> 3.1.0"},
      {:phoenix_live_dashboard, "~> 0.5.3"},
      {:phoenix, "~> 1.6.2"},
      {:plug_cowboy, "~> 2.5.2"},
      {:surface, "~> 0.6.1"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 1.0.0"},
      {:surface_formatter, "~> 0.6.0"}
    ]
  end
end
