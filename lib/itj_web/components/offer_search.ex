defmodule ITJWeb.Components.OfferSearch do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "offer_search.html", assigns)
  end

  def handle_event("offer_search", %{"search" => search}, socket) do
    search = search |> Map.filter(fn {_, v} -> v != "" end)
    path = ITJWeb.Router.Helpers.live_path(socket, ITJWeb.OffersLive, search)
    socket = socket |> push_patch(to: path)
    {:noreply, socket}
  end
end
