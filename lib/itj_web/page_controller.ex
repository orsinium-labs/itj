defmodule ITJWeb.PageController do
  use ITJWeb, :controller
  require Ecto.Query

  def index(conn, _params) do
    offers = Ecto.Query.from(ITJ.Offer) |> ITJ.Repo.all()
    render(conn, "index.html", offers: offers)
  end
end
