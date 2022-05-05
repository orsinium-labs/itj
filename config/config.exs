import Config

config :itj, ITJ.Repo,
  database: "storage.db",
  socket_options: [:inet6]

config :itj,
  ecto_repos: [ITJ.Repo]

config :itj, ITJWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ITJWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Itj.PubSub,
  live_view: [signing_salt: "GekFNg1H"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
import_config("secrets.exs")
