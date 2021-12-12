defmodule ITJWeb.Components.Pagination do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "pagination.html", assigns)
  end
end
