import Config

config :itj, ITJ.Repo, database: "storage.db"

config :itj,
  ecto_repos: [ITJ.Repo]

config :itj, ItjWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ItjWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Itj.PubSub,
  live_view: [signing_salt: "GekFNg1H"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
