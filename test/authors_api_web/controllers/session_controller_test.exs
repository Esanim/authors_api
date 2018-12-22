defmodule AuthorsApi.SessionControllerTest do
  use AuthorsApiWeb.ConnCase

  alias AuthorsApi.Session
  alias AuthorsApi.Author
  alias AuthorsApi.Repo

  @valid_attrs %{first_name: "James", last_name: "Bagzynski", age: 18}

  setup %{conn: conn} do
    changeset = Author.changeset(%Author{}, @valid_attrs)
    Repo.insert(changeset)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post(conn, Routes.session_path(conn, :create), author: @valid_attrs)
    assert token = json_response(conn, 201)["data"]["token"]
    assert Repo.get_by(Session, token: token)
  end

  test "does not create resource and renders errors when first_name is invalid", %{conn: conn} do
    conn =
      post conn, Routes.session_path(conn, :create),
        author: Map.put(@valid_attrs, :first_name, "Ab")

    assert json_response(conn, 401)["errors"] != %{}
  end

  test "does not create resource and renders errors when last_name is invalid", %{conn: conn} do
    conn =
      post conn, Routes.session_path(conn, :create), author: Map.put(@valid_attrs, :last_name, "")

    assert json_response(conn, 401)["errors"] != %{}
  end
end
