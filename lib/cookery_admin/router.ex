defmodule CookeryAdmin.Router do
  use CookeryAdmin, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, handler: CookeryWeb.AuthController
  end

  scope "/", CookeryAdmin do
    pipe_through [:browser, :browser_auth, :require_login]

    get "/", DashboardController, :index

    resources "/users", UserController do
      get "/change_password", UserController, :change_password
      put "/update_password", UserController, :update_password
    end

    resources "/recipes", RecipeController
  end
end
