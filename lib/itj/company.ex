defmodule ITJ.Company do
  use Ecto.Schema

  schema "companies" do
    field(:title, :string)
    field(:domain, :string)
  end

  @spec get(bitstring) :: ITJ.Offer | nil
  def get(domain) when is_bitstring(domain) do
    ITJ.Repo.get_by(ITJ.Company, domain: domain)
  end

  @spec add(Ecto.Multi.t(), map) :: Ecto.Multi.t()
  def add(multi, company) when is_map(company) do
    old = ITJ.Company.get(company.domain) || %ITJ.Company{}
    changes = ITJ.Company.changeset(old, company)
    Ecto.Multi.insert_or_update(multi, {:companies, company.domain}, changes)
  end

  def changeset(company, attrs) when is_struct(company, ITJ.Company) do
    company
    |> Ecto.Changeset.cast(attrs, [:title, :domain])
    |> Ecto.Changeset.validate_required([:title, :domain])
    |> Ecto.Changeset.validate_format(:domain, ~r"^[a-z0-9_\.\-]+")
    |> Ecto.Changeset.unique_constraint(:domain)
  end
end
