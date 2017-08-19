defmodule CookeryWeb.AuthController do
  use CookeryWeb, :controller

  alias Cookery.Data.Accounts
  alias Cookery.Data.Accounts.User

  def login_form(conn, params) do
    render conn, "login_form.html", redirect_to: redirect_to(params)
  end

  def login(conn, %{"user" => params}) do
    case Accounts.find_and_confirm_password(params["login"], params["password"]) do
      {:ok, user} ->
         conn
         |> Guardian.Plug.sign_in(user)
         |> redirect(to: redirect_to(params))
      {:error, _} ->
        conn
        |> put_flash(:error, "User not found or password invalid")
        |> render "login_form.html"
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end

  def unauthenticated(conn, params) do
    conn
    |> redirect(to: "/login?redirect_to=#{conn.request_path}")
  end

  defp redirect_to(params) do
    params["redirect_to"] || "/"
  end
end
