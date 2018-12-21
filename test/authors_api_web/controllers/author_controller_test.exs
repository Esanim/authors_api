defmodule AuthorsApi.AuthorControllerTest do
  use AuthorsApiWeb.ConnCase

  alias AuthorsApi.Author
  alias AuthorsApi.Repo

  @valid_attrs %{first_name: "James", last_name: "Bagzynski", age: 18}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post(conn, Routes.author_path(conn, :create), author: @valid_attrs)
    body = json_response(conn, 201)
    assert body["data"]["id"]
    assert body["data"]["first_name"]
    assert body["data"]["last_name"]
    assert body["data"]["age"]
    refute body["data"]["pet_name"]
    assert Repo.get_by(Author, first_name: "James")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, Routes.author_path(conn, :create), author: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

end
