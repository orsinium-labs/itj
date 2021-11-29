import Config

config :itj, ITJ.Repo, database: "storage.db"

config :itj,
  ecto_repos: [ITJ.Repo]
