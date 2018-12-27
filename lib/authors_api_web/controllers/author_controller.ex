defmodule AuthorsApiWeb.AuthorController do
  use AuthorsApiWeb, :controller

  alias AuthorsApi.Author
  alias AuthorsApi.Repo

  action_fallback AuthorsApiWeb.FallbackController

  def index(conn, _params) do
    authors = Repo.all(Author)
    render(conn, "show.json", authors: authors)
  end

  def create(conn, %{"author" => author_params}) do
    changeset = Author.changeset(%Author{}, author_params)
    with {:ok, %Author{} = author} <- Repo.insert(changeset) do
      conn
      |> put_status(:created)
      |> render("show.json", author: author)
    end
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Repo.get!(Author, id)
    changeset = Author.changeset(author, author_params)

    with {:ok, %Author{} = author} <- Repo.update(changeset) do
      conn
      |> render("show.json", author: author)
    end
  end

end
