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
    {:ok, offers} = args |> hd |> ITJ.Recruitee.add_offers()
    count = map_size(offers)
    IO.puts("Inserted #{count} offers")
  end
end
