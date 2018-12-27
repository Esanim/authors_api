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

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug AuthorsApiWeb.Authentication
  end

  scope "/", AuthorsApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", AuthorsApiWeb do
    pipe_through :api

    resources "/authors", AuthorController, only: [:create]
    resources "/sessions", SessionController, only: [:create]
  end

  scope "/api", AuthorsApiWeb do
    pipe_through :api_auth

    resources "/articles", ArticleController, except: [:new, :update]
    resources "/authors", AuthorController, expect: [:create, :delete]
  end
end
