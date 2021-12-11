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

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
