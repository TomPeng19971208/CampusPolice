defmodule CampusPoliceWeb.Router do
  use CampusPoliceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CampusPoliceWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", CamousPoliceWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    resources "/records", RecordController, except: [:new, :edit]
    resources "/types", TypeController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CampusPoliceWeb do
  #   pipe_through :api
  # end
end