defmodule ITJWeb.Components.OfferList do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "offer_list.html", assigns)
  end
end
