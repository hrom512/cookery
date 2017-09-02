defmodule CookeryWeb.Loaders do
  import Plug.Conn
  use Timex

  def load_current_user(conn, _opts) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end

  def load_current_timezone(conn, _opts) do
    conn
    |> assign(:current_timezone, Timezone.get("Europe/Moscow"))
  end
end
