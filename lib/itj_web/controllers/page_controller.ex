defmodule ITJWeb.PageController do
  use ITJWeb, :controller

  import Ecto.Query

  def index(conn, _params) do
    conn |> assign(:page_title, "Job Aggregator") |> render("index.html")
  end

  def about(conn, _params) do
    offers_count = from(o in ITJ.Offer, select: count()) |> ITJ.Repo.one()
    companies_count = from(o in ITJ.Company, select: count()) |> ITJ.Repo.one()

    conn
    |> assign(:page_title, "About")
    |> assign(:offers_count, offers_count)
    |> assign(:companies_count, companies_count)
    |> render("about.html")
  end
end
