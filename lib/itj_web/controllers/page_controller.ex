defmodule ITJWeb.PageController do
  use ITJWeb, :controller

  def index(conn, _params) do
    conn |> assign(:page_title, "Job Aggregator") |> render("index.html")
  end
end
