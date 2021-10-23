defmodule ITJ.Recruitee do
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
