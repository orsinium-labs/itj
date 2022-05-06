# ITJ

A job aggregator that crawls sites of individual companies rather than job boards. We have a big goal to foster web decentralization without losing the convenience of centralization.

Powers [itj.orsinium.dev](https://itj.orsinium.dev/).

## Running locally

1. Create `config/secrets.exs`:

  ```elixir
  import Config

  config :itj, :dashboard_auth,
    username: "admin",
    password: "..."

  ```

1. Use `mix phx.server` to start the server.
