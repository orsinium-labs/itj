defmodule ITJWeb.CompanyLive do
  use Phoenix.LiveView
  import Ecto.Query

  def render(assigns) do
    Phoenix.View.render(ITJWeb.PageView, "company.html", assigns)
  end

  def mount(params, _session, socket) do
    query =
      from(company in ITJ.Company, join: link in assoc(company, :links), preload: [links: link])

    company = ITJ.Repo.get_by(query, domain: params["domain"])
    socket = socket |> assign(:company, company) |> assign(:page_title, company.title)
    {:ok, socket}
  end
end
