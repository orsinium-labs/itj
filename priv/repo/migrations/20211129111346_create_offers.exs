defmodule ITJ.Repo.Migrations.CreateOffers do
  use Ecto.Migration

  def change do
    create table(:offers) do
      add(:title, :string, null: false)
      add(:country_code, :string, null: false)
      add(:city, :string, null: false)
      add(:url, :string, null: false, unique: true)
      add(:remote, :boolean, null: false)
    end
  end
end
