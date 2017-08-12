defmodule CookeryWeb.Router do
  use CookeryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", CookeryWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/login", AuthController, :login_form, as: :login
    post "/login", AuthController, :login, as: :login
    get "/logout", AuthController, :logout, as: :logout
  end

  forward "/admin", CookeryAdmin.Plug, [], as: :admin
end
