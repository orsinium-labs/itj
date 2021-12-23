defmodule ITJ.Syncer do
  import Ecto.Query

  def sync() do
    from(company in ITJ.Company, select: company.domain)
    |> ITJ.Repo.all()
    |> sync()
  end

  def sync(domains) do
    Task.Supervisor.async_stream_nolink(ITJ.TaskSupervisor, domains, ITJ.Recruitee, :sync, [],
      ordered: false
    )
    |> Stream.run()
  end
end
