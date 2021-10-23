defmodule Mix.Tasks.Itj.Add do
  use Mix.Task
  @shortdoc "Add a new board"
  @moduledoc """
    Download offers from the given domain
    and save them in the storage.
  """

  def run(args) do
    {:ok, offers} = args |> hd |> ITJ.Recruitee.download_offers()
    offers |> inspect() |> IO.puts()
  end
end
