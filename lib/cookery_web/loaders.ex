defmodule CookeryWeb.Loaders do
  import Plug.Conn

  def load_current_user(conn, _opts) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end
end
