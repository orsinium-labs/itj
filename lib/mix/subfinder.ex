defmodule Mix.Tasks.Itj.Subfinder do
  use Mix.Task
  @impl Mix.Task
  @shortdoc "Find subdomains of recruitee.com using subfinder"
  @moduledoc """
    Download offers from the given domain
    and save them in the storage.
  """

  def run(_) do
    Mix.Task.run("app.start")
    ensure_db()
    {stdout, 0} = System.cmd("subfinder", ["-silent", "-d", "recruitee.com"])

    stdout
    |> String.split()
    |> Enum.filter(&(!ITJ.Company.get(&1)))
    |> Enum.filter(&(&1 != "recruitee.com"))
    |> Enum.each(&add_domain/1)
  end

  defp add_domain(domain) do
    ITJ.Company.add!(%{title: "?", domain: domain})
  end

  defp ensure_db() do
    db_path = Path.absname("storage.db")
    if not File.exists?(db_path), do: Mix.Task.run("ecto.migrate")
  end
end
