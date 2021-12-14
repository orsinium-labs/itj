defmodule ITJWeb.CompanyLive do
  use Phoenix.LiveView
  import Ecto.Query

  def render(assigns) do
    Phoenix.View.render(ITJWeb.PageView, "company.html", assigns)
  end

  def mount(params, _session, socket) do
    company =
      from(company in ITJ.Company,
        join: links in assoc(company, :links),
        join: offers in assoc(company, :offers),
        preload: [links: links],
        preload: [offers: offers]
      )
      |> ITJ.Repo.get_by(domain: params["domain"])

    socket =
      socket
      |> assign(:company, company)
      |> assign(:page_title, company.title)

    {:ok, socket}
  end
end
