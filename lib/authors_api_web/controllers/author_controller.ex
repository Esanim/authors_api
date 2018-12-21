defmodule AuthorsApiWeb.AuthorController do
  use AuthorsApiWeb, :controller

  alias AuthorsApi.Author
  alias AuthorsApi.Repo

  action_fallback AuthorsApiWeb.FallbackController

  # plug :scrub_params, "author" when action in [:create]

  def create(conn, %{"author" => author_params}) do
    changeset = Author.changeset(%Author{}, author_params)

    with {:ok, %Author{} = author} <- Repo.insert(changeset) do
      conn
      |> put_status(:created)
      |> render("show.json", author: author)
    end
  end
end
