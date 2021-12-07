defmodule ITJ.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ITJ.Repo,
      ITJWeb.Telemetry,
      {Phoenix.PubSub, name: Itj.PubSub},
      ITJWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ITJ.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
