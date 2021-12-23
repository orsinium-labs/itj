defmodule ITJ.Repo.Migrations.OffersAddPublishedAt do
  use Ecto.Migration

  def change do
    alter table(:offers) do
      add(:published_at, :utc_datetime, null: false)
    end
  end
end
