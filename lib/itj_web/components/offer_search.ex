defmodule ITJWeb.Components.OfferSearch do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "offer_search.html", assigns)
  end
end
