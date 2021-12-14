defmodule ITJ.Link do
  use Ecto.Schema

  schema "links" do
    field(:url, :string)
    belongs_to(:company, ITJ.Company)
  end

  @spec get(bitstring) :: ITJ.Link | nil
  def get(url) when is_bitstring(url) do
    ITJ.Repo.get_by(ITJ.Link, url: url)
  end

  @spec add(Ecto.Multi.t(), map) :: Ecto.Multi.t()
  def add(multi, link) when is_map(link) do
    old = ITJ.Link.get(link.url) || %ITJ.Link{}
    changes = ITJ.Link.changeset(old, link)
    Ecto.Multi.insert_or_update(multi, {:links, link.url}, changes)
  end

  def changeset(link, attrs) when is_struct(link, ITJ.Link) do
    link
    |> Ecto.Changeset.cast(attrs, [:url, :company_id])
    |> Ecto.Changeset.validate_required([:url, :company_id])
    |> Ecto.Changeset.validate_format(:url, ~r"^https://.+")
    |> Ecto.Changeset.unique_constraint(:url)
  end

  @spec get_domain(bitstring) :: bitstring
  def get_domain(url) do
    URI.parse(url).host |> String.replace_prefix("www.", "")
  end

  @spec get_icon(bitstring) :: bitstring
  def get_icon(domain) do
    if String.ends_with?(domain, ".recruitee.com") do
      "fas fa-fw fa-users"
    else
      case domain do
        "instagram.com" -> "fab fa-fw fa-instagram"
        "facebook.com" -> "fab fa-fw fa-facebook"
        "linkedin.com" -> "fab fa-fw fa-linkedin"
        "twitter.com" -> "fab fa-fw fa-twitter"
        _ -> "fas fa-fw fa-link"
      end
    end
  end
end
