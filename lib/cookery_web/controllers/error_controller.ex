defmodule CookeryWeb.ErrorController do
  use CookeryWeb, :controller

  def unauthenticated(conn, _params) do
    conn
    |> redirect(to: "/login?redirect_to=#{conn.request_path}")
  end

  def unauthorized(conn) do
    conn
    |> send_resp(403, "Access denied")
    |> halt
  end

  def not_found(conn) do
    conn
    |> send_resp(404, "Not found")
    |> halt
  end
end
