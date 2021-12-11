defmodule ITJWeb.Components.OfferList do
  use Phoenix.LiveComponent
  import Ecto.Query

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "offer_list.html", assigns)
  end

  def handle_event("offer_search", %{"search" => search}, socket) do
    offers =
      from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
      |> apply_filters(search)
      |> ITJ.Repo.all()

    {:noreply, assign(socket, :offers, offers)}
  end

  defp apply_filters(query, filters) do
    query |> apply_remote(filters)
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
end
