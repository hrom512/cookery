defmodule CookeryAdmin.DashboardController do
  use CookeryAdmin, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
