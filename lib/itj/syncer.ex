defmodule ITJ.Syncer do
  use GenServer
  import Ecto.Query

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    :timer.send_interval(3_600_000, :sync)
    {:ok, state}
  end

  @impl true
  def handle_info(:sync, state) do
    sync()
    {:noreply, state}
  end

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
