defmodule ITJWeb.Components.OfferCard do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "offer_card.html", assigns)
  end
end
