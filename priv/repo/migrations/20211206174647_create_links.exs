defmodule ITJ.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add(:url, :string, null: false, unique: true)
    end
  end
end
