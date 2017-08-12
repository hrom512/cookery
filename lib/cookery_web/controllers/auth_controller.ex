defmodule CookeryWeb.AuthController do
  use CookeryWeb, :controller

  alias Cookery.Data.Accounts
  alias Cookery.Data.Accounts.User

  def login(conn, params) do
    case Accounts.find_and_confirm_password(params["login"], params["password"]) do
      {:ok, user} ->
         conn
         |> Guardian.Plug.sign_in(user)
         |> redirect(to: "/admin")
      {:error, _} ->
        render conn, "login.html"
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end
end
