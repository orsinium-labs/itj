defmodule ITJWeb.PageView do
  use ITJWeb, :view

  @spec get_page(map) :: integer
  def get_page(%{"page" => page}) do
    page = String.to_integer(page)

    if page > 1 do
      page
    else
      1
    end
  end

  def get_page(_) do
    1
  end

  def get_limit(_) do
    6
  end
end
