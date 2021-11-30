defmodule ITJ.Repo.Migrations.LinkCompanyAndOffers do
  use Ecto.Migration

  def change do
    alter table(:offers) do
      add(:company_id, references(:companies), null: false)
    end
  end
end
