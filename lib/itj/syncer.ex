defmodule ITJ.Syncer do
  use GenServer
  import Ecto.Query

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
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
    domains = Enum.shuffle(domains)

    ITJ.TaskSupervisor
    |> Task.Supervisor.async_stream_nolink(domains, ITJ.Recruitee, :sync, [],
      ordered: false,
      timeout: 10_000,
      # on timeout, kill only the task, not everything
      kill_task: true
    )
    |> Stream.run()
  end
end
