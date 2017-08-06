defmodule CookeryWeb.PageController do
  use CookeryWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
