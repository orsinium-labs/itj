defmodule ITJ.Offer do
  use Ecto.Schema

  schema "offers" do
    field(:title, :string)
    field(:country_code, :string)
    field(:city, :string)
    field(:url, :string)
    field(:remote, :boolean)
    belongs_to(:company, ITJ.Company)
  end

  @spec get(bitstring) :: ITJ.Offer | nil
  def get(url) when is_bitstring(url) do
    ITJ.Repo.get_by(ITJ.Offer, url: url)
  end

  @spec add(Ecto.Multi.t(), map) :: Ecto.Multi.t()
  def add(multi, offer) when is_map(offer) do
    old = ITJ.Offer.get(offer.url) || %ITJ.Offer{}
    changes = ITJ.Offer.changeset(old, offer)
    Ecto.Multi.insert_or_update(multi, {:offers, offer.url}, changes)
  end

  def changeset(offer, attrs) when is_struct(offer, ITJ.Offer) do
    offer
    |> Ecto.Changeset.cast(attrs, [:title, :country_code, :city, :url, :remote, :company_id])
    |> Ecto.Changeset.validate_required([:title, :url])
    |> Ecto.Changeset.validate_format(:url, ~r"^https://[a-z0-9_\.\-]+/.+")
    |> Ecto.Changeset.unique_constraint(:url)
    |> Ecto.Changeset.validate_length(:country_code, is: 2)
  end
end
