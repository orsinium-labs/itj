defmodule ITJWeb.Components.Pagination do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "pagination.html", assigns)
  end

  def handle_event("pagination", %{"page" => page}, socket) do
    params =
      socket.assigns.search
      |> Map.put("page", page)
      |> Map.filter(fn {_, v} -> v != "" end)

    path = ITJWeb.Router.Helpers.live_path(socket, ITJWeb.OffersLive, params)
    socket = socket |> push_patch(to: path)
    {:noreply, socket}
  end
end
