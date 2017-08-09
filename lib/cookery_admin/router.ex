defmodule CookeryAdmin.Router do
  use CookeryAdmin, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", CookeryAdmin do
    pipe_through :browser

    resources "/recipes", RecipeController
  end
end
