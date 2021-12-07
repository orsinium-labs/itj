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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ITJ.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sqlite3, "~> 0.7.1"},
      {:ecto, "~> 3.7.1"},
      {:floki, "~> 0.32.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.6.2"},
      {:phoenix_live_dashboard, "~> 0.6.2"},
      {:phoenix_html, "~> 3.1.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 1.0.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
