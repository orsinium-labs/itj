defmodule Mix.Tasks.Itj.Add do
  use Mix.Task
  @impl Mix.Task
  @shortdoc "Add a new board"
  @moduledoc """
    Download offers from the given domain
    and save them in the storage.
  """

  def run(args) do
    Mix.Task.run("app.start")
    ensure_db()
    domain = hd(args)
    {:ok, offers} = ITJ.Recruitee.sync_offers(domain)
    ITJ.Recruitee.add_links(domain)
    count = map_size(offers)
    IO.puts("Updated #{count} rows")
  end

  defp ensure_db() do
    db_path = Path.absname("storage.db")
    if not File.exists?(db_path), do: Mix.Task.run("ecto.migrate")
  end
end
