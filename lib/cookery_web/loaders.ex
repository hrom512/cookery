defmodule CookeryWeb.Loaders do
  import Plug.Conn
  use Timex

  def load_current_user(conn, _opts) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end

  def load_current_timezone(conn, _opts) do
    conn
    |> assign(:current_timezone, user_timezone(conn.assigns.current_user))
  end

  defp user_timezone(user) do
    case Timezone.get(user.timezone) do
      {:error, _} -> default_timezone
      timezone -> timezone
    end
  end

  defp default_timezone do
    Timezone.get("Europe/Moscow")
  end
end
