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
    ITJ.Release.find_domains()
  end
end
