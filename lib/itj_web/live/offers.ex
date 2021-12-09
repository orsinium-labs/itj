defmodule ITJWeb.OffersLive do
  use Surface.LiveView
  alias ITJWeb.Components.Offers
  import Ecto.Query

  data(offers, :list)

  def render(assigns) do
    ~F"""
    <Offers offers={@offers} />
    """
  end

  def mount(_params, _session, socket) do
    query = from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
    offers = ITJ.Repo.all(query)
    {:ok, assign(socket, :offers, offers)}
  end
end
