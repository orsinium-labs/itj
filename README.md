# ITJ

A job aggregator that crawls sites of individual companies rather than job boards. We have a big goal to foster web decentralization without losing the convenience of centralization.

Will be hosted at [itj.orsinium.dev](https://itj.orsinium.dev/) as soon as I figure out releases...

Example of `config/secrets.exs`:

```elixir
import Config

config :itj, :dashboard_auth,
  username: "admin",
  password: "..."

```
