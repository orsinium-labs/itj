defmodule ITJWeb.Components.OfferList do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "offer_list.html", assigns)
  end

  def handle_event("offer_search", %{"search" => search}, socket) do
    path = ITJWeb.Router.Helpers.live_path(socket, ITJWeb.OffersLive, search)
    socket = push_patch(socket, to: path)
    {:noreply, socket}
  end
end
