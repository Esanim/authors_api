defmodule AuthorsApi.AuthorControllerAuthTest do
  use AuthorsApiWeb.ConnCase

  alias AuthorsApi.Author
  alias AuthorsApi.Repo
  alias AuthorsApi.Session

  @valid_attrs %{first_name: "James", last_name: "Bagzynski", age: 18}
  @update_attrs %{first_name: "Mark", last_name: "Bagzynski", age: 18}

  setup %{conn: conn} do
    author = create_author(@valid_attrs)
    session = create_session(author)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Token token=\"#{session.token}\"")

    {:ok, conn: conn, current_author: author}
  end

  def create_author(author_params) do
    Author.changeset(%Author{}, author_params) |> Repo.insert!()
  end

  def create_session(author) do
    Session.registration_changeset(%Session{author_id: author.id}, %{}) |> Repo.insert!()
  end

  test "updates and renders resource when data is valid", %{conn: conn, current_author: current_author} do
    conn = put(conn, Routes.author_path(conn, :update, current_author.id), author: @update_attrs)
    body = json_response(conn, 200)
    assert body["data"]["id"]

    refute current_author.first_name == body["data"]["first_name"]
    assert Repo.get_by(Author, @update_attrs)
  end
end
