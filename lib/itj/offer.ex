defmodule ITJ.Offer do
  use Ecto.Schema

  schema "offers" do
    field(:title, :string)
    field(:country_code, :string)
    field(:city, :string)
    field(:url, :string)
    field(:remote, :boolean)
  end

  def changeset(offer, attrs \\ %{}) when is_struct(offer, ITJ.Offer) do
    offer
    |> Ecto.Changeset.cast(attrs, [:title, :country_code, :city, :url, :remote])
    |> Ecto.Changeset.validate_required([:title, :url])
    |> Ecto.Changeset.validate_format(:url, ~r"^https://[a-z0-9_\.\-]+/.+")
    |> Ecto.Changeset.unique_constraint(:url)
    |> Ecto.Changeset.validate_length(:country_code, is: 2)
  end
end
