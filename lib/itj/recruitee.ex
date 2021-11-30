defmodule ITJ.Recruitee do
  def add_offers(base_url) when is_bitstring(base_url) do
    case download_offers(base_url) do
      {:ok, offers} ->
        add_offers(offers)

      {:error, err} ->
        {:error, err}
    end
  end

  def add_offers(offers) when is_list(offers) do
    multi = Ecto.Multi.new()
    add_offers(multi, offers)
  end

  @spec add_offers(Ecto.Multi.t(), [map]) :: map
  def add_offers(multi, [offer | offers]) do
    multi = add_offer(multi, offer)
    add_offers(multi, offers)
  end

  def add_offers(multi, []) do
    ITJ.Repo.transaction(multi)
  end

  @spec add_offer(Ecto.Multi.t(), map) :: Ecto.Multi.t()
  def add_offer(multi, offer) when is_map(offer) do
    new = %{
      title: offer["title"],
      country_code: offer["country_code"],
      city: offer["city"],
      url: offer["careers_url"],
      remote: offer["remote"]
    }

    ITJ.Offer.add(multi, new)
  end

  def download_offers(base_url) when is_bitstring(base_url) do
    base_url |> URI.parse() |> download_offers
  end

  def download_offers(base_url) when is_struct(base_url, URI) do
    url = "https://#{base_url.host}/api/offers/"
    HTTPoison.start()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_offers(body)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Unexpected status code: #{code}"}

      {:error, err} ->
        {:error, err}
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
end
