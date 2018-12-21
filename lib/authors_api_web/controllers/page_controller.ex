defmodule AuthorsApiWeb.PageController do
  use AuthorsApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
