defmodule ITJ.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add(:title, :string, null: false)
      add(:domain, :string, null: false, unique: true)
    end
  end
end
