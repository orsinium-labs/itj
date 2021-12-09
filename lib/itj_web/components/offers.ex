defmodule ITJWeb.Components.Offers do
  use Surface.Component
  alias ITJWeb.Components.OfferCard

  @doc "The list of offers to render"
  prop(offers, :list)
end
