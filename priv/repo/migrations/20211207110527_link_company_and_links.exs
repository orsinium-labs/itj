defmodule ITJ.Repo.Migrations.LinkCompanyAndLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add(:company_id, references(:companies), null: false)
    end
  end
end
