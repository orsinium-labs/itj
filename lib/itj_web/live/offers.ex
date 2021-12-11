defmodule ITJWeb.OffersLive do
  use Phoenix.LiveView
  import Ecto.Query

  def render(assigns) do
    Phoenix.View.render(ITJWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    query = from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
    offers = ITJ.Repo.all(query)
    {:ok, assign(socket, :offers, offers)}
  end

  def handle_params(%{"search" => search}, _uri, socket) do
    offers =
      from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
      |> apply_filters(search)
      |> ITJ.Repo.all()

    socket = assign(socket, :offers, offers)
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp apply_filters(query, filters) do
    query |> apply_remote(filters) |> apply_title(filters)
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
end
