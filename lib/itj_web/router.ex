defmodule ITJWeb.Router do
  use ITJWeb, :router
  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_root_layout, {ITJWeb.LayoutView, :root})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :admins_only do
    plug(:basic_auth, Application.compile_env(:itj, :dashboard_auth))
  end

  scope "/", ITJWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/about", PageController, :about)
    live("/offers", OffersLive)
    live("/company/:domain", CompanyLive)
  end

  scope "/api", ITJWeb do
    pipe_through(:api)
  end

  scope "/" do
    pipe_through([:fetch_session, :protect_from_forgery, :admins_only])
    live_dashboard("/dashboard", metrics: ITJWeb.Telemetry)
  end
end
