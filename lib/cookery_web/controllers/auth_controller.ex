defmodule CookeryWeb.AuthController do
  use CookeryWeb, :controller

  alias Cookery.Data.Accounts
  alias Cookery.Data.Accounts.User

  def login_form(conn, _params) do
    render conn, "login_form.html"
  end

  def login(conn, %{"user" => params}) do
    case Accounts.find_and_confirm_password(params["login"], params["password"]) do
      {:ok, user} ->
         conn
         |> Guardian.Plug.sign_in(user)
         |> redirect(to: "/admin")
      {:error, _} ->
        render conn, "login_form.html"
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end

  def unauthenticated(conn, params) do
    conn
    |> put_flash(:info, "Authentication required")
    |> redirect(to: "/login")
  end
end
