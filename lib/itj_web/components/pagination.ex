defmodule ITJWeb.Components.Pagination do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "pagination.html", assigns)
  end

  def handle_event("pagination", %{"page" => _} = params, socket) do
    path = ITJWeb.Router.Helpers.live_path(socket, ITJWeb.OffersLive, params)
    socket = push_patch(socket, to: path)
    {:noreply, socket}
  end
end
