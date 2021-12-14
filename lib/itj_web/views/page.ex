defmodule ITJWeb.PageView do
  use ITJWeb, :view

  def get_page(%{"page" => page}) do
    String.to_integer(page)
  end

  def get_page(_) do
    1
  end

  def get_per_page(_) do
    4
  end
end
