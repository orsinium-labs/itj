defmodule ITJ.Recruitee do
  require Ecto.Query

  @doc """
  Synchronize the local storage with remote offers.

  + new offers will be added
  + updated offers will be updated
  + removed offers will be removed
  """
  def sync_offers(base_url) when is_bitstring(base_url) do
    case download_offers(base_url) do
      {:ok, offers} ->
        sync_offers(offers)

      {:error, err} ->
        {:error, err}
    end
  end

  def sync_offers(offers) when is_list(offers) do
    case add_company(offers) do
      {:ok, company} -> sync_offers(company, offers)
      {:error, err} -> {:error, err}
      nil -> {:ok, %{}}
    end
  end

  def sync_offers(company, offers) do
    remove_outdated_offers(company, offers)
    multi = Ecto.Multi.new()
    multi = Enum.reduce(offers, multi, &add_offer(&2, &1, company))
    ITJ.Repo.transaction(multi)
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
    new = %{
      title: offer["company_name"],
      domain: URI.parse(offer["careers_url"]).host
    }

    ITJ.Company.add(new)
  end

  @doc """
  Download offers from the remote server using Recruitee API.

  https://docs.recruitee.com/reference/offers
  """
  def download_offers(base_url) do
    domain = extract_domain(base_url)

    if String.match?(domain, ~r"^[a-z0-9_\.\-]+\.recruitee\.com") do
      request_offers(domain)
    else
      {:error, "Invalid domain name"}
    end
  end

  defp request_offers(domain) do
    url = "https://#{domain}/api/offers/"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_offers(body)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Unexpected status code: #{code}"}

      {:error, err} ->
        {:error, err}
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

  def parse_offers(body) when is_binary(body) do
    case(Jason.decode(body)) do
      {:ok, content} ->
        %{"offers" => offers} = content
        {:ok, offers}

      {:error, err} ->
        {:error, err}
    end
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

  def add_links(base_url) when is_bitstring(base_url) do
    case download_links(base_url) do
      {:ok, links} ->
        add_links(links)

      {:error, err} ->
        {:error, err}
    end
  end

  def add_links(links) when is_list(links) do
    multi = Ecto.Multi.new()
    multi = Enum.reduce(links, multi, &add_link(&2, &1))
    ITJ.Repo.transaction(multi)
  end

  def add_link(multi, link) do
    new = %{url: link}
    ITJ.Link.add(multi, new)
  end

  def download_links(base_url) when is_bitstring(base_url) do
    domain = extract_domain(base_url)
    url = "https://#{domain}/"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, doc} = Floki.parse_document(body)
        parse_links(doc)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Unexpected status code: #{code}"}

      {:error, err} ->
        {:error, err}
    end
  end

  def parse_links(doc) when is_list(doc) do
    links =
      Floki.find(doc, "a[rel~=noopener]")
      |> Enum.flat_map(fn el -> Floki.attribute(el, "href") end)
      |> Enum.filter(fn link -> link != "https://recruitee.com" end)

    {:ok, links}
  end
end
