defmodule ITJ.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :itj

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  @doc """
  This job is meant to be executed on a running instance.
  For releases, use `./bin/itj rpc ITJ.Release.find_domains`.
  """
  def find_domains(subfinder_path \\ "subfinder") do
    ensure_db()
    {stdout, 0} = System.cmd(subfinder_path, ["-silent", "-d", "recruitee.com"])

    stdout
    |> String.split()
    |> Enum.filter(fn domain -> !ITJ.Company.get(domain) and domain != "recruitee.com" end)
    |> Enum.each(&add_domain/1)
  end

  defp add_domain(domain) do
    ITJ.Company.add!(%{title: "?", domain: domain})
  end

  defp ensure_db() do
    db_path = Path.absname("storage.db")
    if not File.exists?(db_path), do: migrate()
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
