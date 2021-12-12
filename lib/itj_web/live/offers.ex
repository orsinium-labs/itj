defmodule ITJWeb.OffersLive do
  use Phoenix.LiveView
  import Ecto.Query

  def render(assigns) do
    Phoenix.View.render(ITJWeb.PageView, "index.html", assigns)
  end

  def mount(params, _session, socket) do
    {:noreply, socket} = handle_params(params, nil, socket)
    cities = from(offer in ITJ.Offer, select: offer.city, distinct: true) |> ITJ.Repo.all()
    socket = socket |> assign(:cities, cities)
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    offers =
      from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
      |> apply_filters(params)
      |> ITJ.Repo.all()

    socket =
      socket
      |> assign(:offers, offers)
      |> assign(:search, params)

    {:noreply, socket}
  end

  defp apply_filters(query, filters) do
    query |> apply_remote(filters) |> apply_title(filters) |> apply_city(filters)
  end

  defp apply_remote(query, %{"remote" => "yes"}) do
    where(query, remote: true)
  end

  defp apply_remote(query, %{"remote" => "no"}) do
    where(query, remote: false)
  end

  defp apply_remote(query, _) do
    query
  end

  defp apply_title(query, %{"title" => ""}) do
    query
  end

  defp apply_title(query, %{"title" => title}) do
    title = Regex.replace(~r/[^a-zA-Z]+/, title, " ")
    title = Regex.replace(~r/\s+/, title, "%")
    where(query, [o], like(o.title, ^"%#{title}%"))
  end

  defp apply_title(query, _) do
    query
  end

  defp apply_city(query, %{"city" => ""}) do
    query
  end

  defp apply_city(query, %{"city" => city}) do
    where(query, city: ^city)
  end

  defp apply_city(query, _) do
    query
  end
end
