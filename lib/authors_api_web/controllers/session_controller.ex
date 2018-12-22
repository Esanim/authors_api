defmodule AuthorsApiWeb.SessionController do
  use AuthorsApiWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias AuthorsApi.Session
  alias AuthorsApi.Repo

  action_fallback AuthorsApiWeb.FallbackController

  def create(conn, %{"author" => author_params}) do
    # Create a query
    query =
      from a in "authors",
        where: a.first_name == ^author_params["first_name"],
        where: a.last_name == ^author_params["last_name"],
        select: a.id

    id = Repo.one(query)

    cond do
      id ->
        changeset = Session.registration_changeset(%Session{}, %{author_id: id})

        with {:ok, session} = Repo.insert(changeset) do
          conn
          |> put_status(:created)
          |> render("show.json", session: session)
        end

      true ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", author_params)
    end
  end
end
