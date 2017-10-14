defmodule CookeryWeb.Loaders do
  @moduledoc false

  import Plug.Conn
  use Timex

  alias Guardian.Plug, as: GuardianPlug

  def load_current_user(conn, _opts) do
    conn
    |> assign(:current_user, GuardianPlug.current_resource(conn))
  end

  def load_current_timezone(conn, _opts) do
    conn
    |> assign(:current_timezone, user_timezone(conn.assigns.current_user))
  end

  defp user_timezone(user) do
    case Timezone.get(user.timezone) do
      {:error, _} -> default_timezone()
      timezone -> timezone
    end
  end

  defp default_timezone do
    timezone_string = Application.get_env(:cookery, :default_timezone)
    Timezone.get(timezone_string)
  end
end
