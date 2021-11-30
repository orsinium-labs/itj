defmodule ITJ.Company do
  use Ecto.Schema

  schema "companies" do
    field(:title, :string)
    field(:domain, :string)
    has_many(:offers, ITJ.Offer)
  end

  @spec get(bitstring) :: ITJ.Offer | nil
  def get(domain) when is_bitstring(domain) do
    ITJ.Repo.get_by(ITJ.Company, domain: domain)
  end

  def add(company) when is_map(company) do
    old = ITJ.Company.get(company.domain) || %ITJ.Company{}
    changes = ITJ.Company.changeset(old, company)
    ITJ.Repo.insert_or_update(changes)
  end

  def changeset(company, attrs) when is_struct(company, ITJ.Company) do
    company
    |> Ecto.Changeset.cast(attrs, [:title, :domain])
    |> Ecto.Changeset.validate_required([:title, :domain])
    |> Ecto.Changeset.validate_format(:domain, ~r"^[a-z0-9_\.\-]+\.recruitee\.com")
    |> Ecto.Changeset.unique_constraint(:domain)
  end
end
