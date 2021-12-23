defmodule ITJWeb.ComponentHelpers do
  import Phoenix.LiveView.Helpers

  def text_input(%{form: form, field: field} = assigns) do
    opts =
      assigns
      |> Map.drop([:form, :field, :__changed__])
      |> Map.put_new(:class, "form-control")
      |> Keyword.new()

    ~H"<%= Phoenix.HTML.Form.text_input(form, field, opts) %>"
  end

  def radio_button(%{form: form, field: field, value: value} = assigns) do
    opts =
      assigns
      |> Map.drop([:form, :field, :value, :__changed__])
      |> Keyword.new()

    ~H"<%= Phoenix.HTML.Form.radio_button(form, field, value, opts) %>"
  end

  def form_label(%{form: form, field: field, value: value} = assigns) do
    opts =
      assigns
      |> Map.drop([:form, :field, :value, :__changed__])
      |> Keyword.new()

    ~H"<%= Phoenix.HTML.Form.label(form, field, value, opts) %>"
  end
end
