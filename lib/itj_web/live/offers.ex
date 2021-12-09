defmodule ITJWeb.OffersLive do
  use Surface.LiveView
  alias ITJWeb.Components.Offers
  alias ITJWeb.Components.OfferSearch
  import Ecto.Query

  data(offers, :list)

  def render(assigns) do
    ~F"""
      <div class="container">
        <div class="row">
          <div class="col-md-4 col-lg-3">
            <OfferSearch />
          </div>
          <div class="col">
            <Offers offers={@offers} />
          </div>
        </div>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    query = from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
    offers = ITJ.Repo.all(query)
    {:ok, assign(socket, :offers, offers)}
  end
end
