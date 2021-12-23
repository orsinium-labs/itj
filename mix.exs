defmodule ITJ.MixProject do
  use Mix.Project

  def project do
    [
      app: :itj,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
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
      {:date_time_parser, "~> 1.1.2"},
      {:ecto_sqlite3, "~> 0.7.1"},
      {:ecto, "~> 3.7.1"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:floki, "~> 0.32.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:phoenix_html, "~> 3.1.0"},
      {:phoenix_live_dashboard, "~> 0.6.2"},
      {:phoenix_live_view, "~> 0.17.5"},
      {:phoenix, "~> 1.6.4"},
      {:plug_cowboy, "~> 2.5.2"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 1.0.0"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"],
      "phx.routes": ["phx.routes ITJWeb.Router"]
    ]
  end
end
