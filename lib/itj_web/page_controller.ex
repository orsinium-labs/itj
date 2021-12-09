defmodule ITJWeb.PageController do
  use ITJWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    query = from(o in ITJ.Offer, join: c in assoc(o, :company), preload: [company: c])
    offers = ITJ.Repo.all(query)
    render(conn, "index.html", offers: offers)
  end
end
