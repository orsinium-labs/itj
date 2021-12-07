import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :itj, ITJWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "XgB+Zfx3CTmY1MESabDa1m6eKhQTrDZHD1meMlG9Uo3iTDbTQpVDWFGZZalrdY0w",
  server: false

config :logger, level: :warn
config :phoenix, :plug_init_mode, :runtime
