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
    domain = args |> hd |> ITJ.Recruitee.sanitize_url()

    if domain do
      records = ITJ.Recruitee.sync(domain)
      IO.puts("Updated #{records} records")
    else
      IO.puts("Invalid domain")
    end
  end

  defp ensure_db() do
    db_path = Path.absname("storage.db")
    if not File.exists?(db_path), do: Mix.Task.run("ecto.migrate")
  end
end
