defmodule CookeryWeb.AuthController do
  use CookeryWeb, :controller

  alias Guardian.Plug, as: GuardianPlug
  alias Cookery.Data.Accounts

  def login_form(conn, params) do
    render conn, "login_form.html", redirect_to: redirect_to(params)
  end

  def login(conn, %{"user" => params}) do
    case Accounts.find_and_confirm_password(params["login"], params["password"]) do
      {:ok, user} ->
         conn
         |> GuardianPlug.sign_in(user)
         |> redirect(to: redirect_to(params))
      {:error, _} ->
        conn
        |> put_flash(:error, "User not found or password invalid")
        |> render("login_form.html", redirect_to: redirect_to(params))
    end
  end

  def logout(conn, _params) do
    conn
    |> GuardianPlug.sign_out
    |> redirect(to: "/")
  end

  defp redirect_to(params) do
    params["redirect_to"] || "/"
  end
end
