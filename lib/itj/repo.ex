defmodule ITJ.Repo do
  use Ecto.Repo,
    otp_app: :itj,
    adapter: Ecto.Adapters.SQLite3
end
