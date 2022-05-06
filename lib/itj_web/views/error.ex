defmodule ITJWeb.ErrorView do
  use ITJWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  def render(_, %{reason: %Ecto.NoResultsError{}, conn: conn}) do
    assigns = %{page_title: "Record not found", conn: conn}
    Phoenix.View.render(ITJWeb.PageView, "error.html", assigns)
  end

  def render(_, %{reason: %Phoenix.Router.NoRouteError{}, conn: conn}) do
    assigns = %{page_title: "Page not found", conn: conn}
    Phoenix.View.render(ITJWeb.PageView, "error.html", assigns)
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)

    # TODO: How does it get rendered? Why it fails with
    # "protocol Phoenix.HTML.Safe not implemented for ... Map"?
    # %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
