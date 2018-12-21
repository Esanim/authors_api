defmodule AuthorsApiWeb.Router do
  use AuthorsApiWeb, :router

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

  scope "/", AuthorsApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", AuthorsApiWeb do
    pipe_through :api

    resources "/articles", ArticleController, except: [:new, :edit]
    resources "/authors", AuthorController, only: [:create]
  end
end
