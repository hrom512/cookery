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

  scope "/", CookeryAdmin do
    pipe_through [:browser, :browser_auth]

    get "/", DashboardController, :index

    resources "/recipes", RecipeController
  end
end
