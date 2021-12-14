defmodule ITJ.Recruitee do
  require Ecto.Query
  @behaviour ITJ.Provider

  @impl ITJ.Provider
  def sanitize_url(base_url) do
    domain = extract_domain(base_url)

    if String.match?(domain, ~r"^[a-z0-9_\.\-]+\.recruitee\.com") do
      domain
    else
      nil
    end
  end

  defp extract_domain(url) do
    cond do
      String.starts_with?(url, "https://") ->
        URI.parse(url).host

      String.starts_with?(url, "http://") ->
        URI.parse(url).host

      true ->
        url
    end
  end

  @impl ITJ.Provider
  def sync(domain) when is_bitstring(domain) do
    offers = download_offers(domain)
    sync(offers)
  end

  def sync(offers) when is_list(offers) do
    company = add_company(offers)
    links = add_links(company)
    offers = add_offers(company, offers)
    1 + map_size(links) + map_size(offers)
  end

  def add_offers(company, offers) do
    remove_outdated_offers(company, offers)
    multi = Ecto.Multi.new()
    multi = Enum.reduce(offers, multi, &add_offer(&2, &1, company))
    {:ok, offers} = ITJ.Repo.transaction(multi)
    offers
  end

  @doc """
  Add the given offer into the storage.

  If offer already exists in the storage, it will be updated.
  """
  def add_offer(multi, offer, company) when is_map(offer) do
    new = %{
      title: offer["title"],
      country_code: offer["country_code"],
      city: offer["city"],
      url: offer["careers_url"],
      remote: offer["remote"],
      company_id: company.id
    }

    ITJ.Offer.add(multi, new)
  end

  @doc """
  Extract the company info from the offers and add it into the storage.

  If the company already exists in storage, it will be updated.
  """
  def add_company([offer | _]) do
    add_company(offer)
  end

  def add_company([]) do
    nil
  end

  def add_company(offer) when is_map(offer) do
    domain = URI.parse(offer["careers_url"]).host

    new = %{
      title: offer["company_name"],
      domain: domain
    }

    ITJ.Company.add!(new)
  end

  @doc """
  Download offers from the remote server using Recruitee API.

  https://docs.recruitee.com/reference/offers
  """
  def download_offers(domain) do
    url = "https://#{domain}/api/offers/"
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(url)
    %{"offers" => offers} = Jason.decode!(body)
    offers
  end

  @doc """
  Remove from the storage all offers for the given `company`
  that aren't listed in `current_offers`.
  """
  def remove_outdated_offers(company, current_offers) when is_struct(company, ITJ.Company) do
    current_urls = Enum.map(current_offers, & &1["url"])

    query =
      Ecto.Query.from(
        offer in ITJ.Offer,
        where: offer.company_id == ^company.id and offer.url not in ^current_urls
      )

    {count, nil} = ITJ.Repo.delete_all(query)
    count
  end

  @doc """
  Extract links to the company resources and store them in storage.
  """
  def add_links(company) when is_map(company) do
    links = download_links(company.domain)
    add_links(links, company)
  end

  def add_links(links, company) when is_list(links) do
    multi = Ecto.Multi.new()
    multi = Enum.reduce(links, multi, &add_link(&2, &1, company))
    {:ok, links} = ITJ.Repo.transaction(multi)
    links
  end

  def add_link(multi, link, company) do
    new = %{url: link, company_id: company.id}
    ITJ.Link.add(multi, new)
  end

  def download_links(base_url) when is_bitstring(base_url) do
    domain = extract_domain(base_url)
    url = "https://#{domain}/"

    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(url)
    document = Floki.parse_document!(body)

    social_links =
      document
      |> Floki.find("a[rel~=noopener]")
      |> Enum.flat_map(fn el -> Floki.attribute(el, "href") end)
      |> Enum.filter(fn link -> link != "https://recruitee.com" end)

    company_links =
      document
      |> Floki.find("a[class~=company-link]")
      |> Enum.flat_map(fn el -> Floki.attribute(el, "href") end)

    social_links ++ company_links
  end
end
