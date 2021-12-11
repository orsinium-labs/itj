defmodule ITJWeb.Components.OfferList do
  use Phoenix.LiveComponent
  import Ecto.Query

  def render(assigns) do
    Phoenix.View.render(ITJWeb.ComponentView, "offer_list.html", assigns)
  end

  def handle_event("offer_search", %{"search" => search}, socket) do
    offers =
      from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
      |> apply_filters(search)
      |> ITJ.Repo.all()

    socket =
      socket
      |> push_patch(
        to: ITJWeb.Router.Helpers.live_path(socket, ITJWeb.OffersLive, %{"search" => search})
      )
      |> assign(:offers, offers)

    {:noreply, socket}
  end

  defp apply_filters(query, filters) do
    query |> apply_remote(filters) |> apply_title(filters)
  end

  defp apply_remote(query, %{"remote" => "yes"}) do
    where(query, remote: true)
  end

  defp apply_remote(query, %{"remote" => "no"}) do
    where(query, remote: false)
  end

  defp apply_remote(query, _) do
    query
  end

  defp apply_title(query, %{"title" => ""}) do
    query
  end

  defp apply_title(query, %{"title" => title}) do
    title = Regex.replace(~r/[^a-zA-Z]+/, title, " ")
    title = Regex.replace(~r/\s+/, title, "%")
    where(query, [o], like(o.title, ^"%#{title}%"))
  end
end
